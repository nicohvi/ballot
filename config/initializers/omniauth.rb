Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '583654638581-44iiak51g69s22f1dgqqsg89k62v8e72.apps.googleusercontent.com', 'ywdxtd49bauRv64ciWfry0jS',
      {
        scope: 'email'
      }
end
