module JsEnv
  extend ActiveSupport::Concern

  included do
    helper_method :js_env
  end

  def push_to_js_env(hash)
    js_env_data.deep_merge!(hash)
  end

  private

  def js_env
    <<-EOS.html_safe
<script type="text/javascript">
  window.JsEnv = #{js_env_data.to_json};
</script>
    EOS
  end

  def js_env_data
    @js_env_data ||= {
        env: Rails.env,
        cl: {
            api_key: Cloudinary.config.api_key,
            upload_url: Cloudinary::Utils.cloudinary_api_url("upload", resource_type: :auto),
            upload_preset: 'tripjournal',
        }
    }
  end
end