require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Weixin < OmniAuth::Strategies::OAuth2
      option :name, "weixin"

      option :client_options, {
        site:          "https://api.weixin.qq.com",
        authorize_url: "https://open.weixin.qq.com/connect/qrconnect#wechat_redirect",
        token_url:     "/sns/oauth2/access_token",
        token_method:  :get
      }

      option :authorize_params, {scope: "snsapi_login"}

      option :token_params, {parse: :json}

      uid do
        raw_info['unionid']
      end

      info do
        {
          openid:     raw_info["openid"],
          nickname:   raw_info['nickname'],
          sex:        raw_info['sex'],
          province:   raw_info['province'],
          city:       raw_info['city'],
          country:    raw_info['country'],
          image:      raw_info['headimgurl']
        }
      end

      extra do
        {raw_info: raw_info}
      end

      # doc https://github.com/intridea/omniauth/wiki/Strategy-Contribution-Guide
      def request_phase
        params = client.auth_code.authorize_params.merge(redirect_uri: callback_url).merge(authorize_params)
        params["appid"] = params.delete("client_id")
        redirect client.authorize_url(params)
      end

      def raw_info
        @uid ||= access_token["openid"]
        @raw_info ||= begin
          access_token.options[:mode] = :query
          # access_token's scope is "snsapi_login" not snsapi_userinfo(fuck), when we want to get userinfo in the /sns/userinfo
          if access_token["scope"] && access_token["scope"].include?("snsapi_login")
            @raw_info = access_token.get("/sns/userinfo", :params => {"openid" => @uid}, parse: :json).parsed
          else
            @raw_info = {"openid" => @uid }
          end
        end
      end

      protected

      # doc http://www.rubydoc.info/gems/oauth2/1.0.0/file/README.md
      def build_access_token
        params = {
          'appid' => client.id, 
          'secret' => client.secret,
          'code' => request.params['code'],
          'grant_type' => 'authorization_code' 
          }.merge(token_params.to_hash(symbolize_keys: true))
        client.get_token(params, deep_symbolize(options.auth_token_params))
      end

    end
  end
end