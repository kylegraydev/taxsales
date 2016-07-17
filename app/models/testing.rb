class Testing
  include HideMyAss

  HideMyAss.options[:max_concurrency] = 3
  rresponse = HideMyAss.get("www.google.com", timeout: 2)

  binding.pry
end
