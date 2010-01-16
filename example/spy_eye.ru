require 'ww/spy_eye'

app = Ww::SpyEye.to_app do
  spy(:get, "/hello") do
    "Hello World"
  end

  spy(:post, "/hello") do
    redirect "/hello"
  end
end

run app

