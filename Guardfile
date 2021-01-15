# Defines the matching rules for Guard.
guard :minitest, spring: 'bin/rails test', all_on_start: false do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch('test/test_helper.rb') { 'test' }
  watch('config/routes.rb') { interface_tests }
  watch(%r{app/views/layouts/*}) { interface_tests }
  watch(%r{^app/models/(.*?)\.rb$}) do |matches|
    'test/models/#{matches[1]}_test.rb'
  end
  watch(%r{^app/controllers/(.*?)_controller\.rb$}) do |matches|
    resource_tests(matches[1])
  end
  watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |matches|
    ['test/controllers/#{matches[1]}_controller_test.rb'] +
    integration_tests(matches[1])
  end
  watch(%r{^app/helpers/(.*?)_helper\.rb$}) do |matches|
    integration_tests(matches[1])
  end
  watch('app/views/layouts/application.html.erb') do
    'test/integration/site_layout_test.rb'
  end
  watch('app/helpers/sessions_helper.rb') do
    integration_tests << 'test/helpers/sessions_helper_test.rb'
  end
  watch('app/controllers/sessions_controller.rb') do
    ['test/controllers/sessions_controller_test.rb',
     'test/integration/users_login_test.rb']
  end
  watch('app/controllers/account_activations_controller.rb') do
    'test/integration/users_signup_test.rb'
  end
  watch(%r{app/views/users/*}) do
    resource_tests('users') +
    ['test/integration/microposts_interface_test.rb']
  end
end

# Returns the integration tests corresponding to the given resource.
def integration_tests(resource = :all)
  if resource == :all
    Dir['test/integration/*']
  else
    Dir['test/integration/#{resource}_*.rb']
  end
end

# Returns all tests that hit the interface.
def interface_tests
  integration_tests << 'test/controllers/'
end

# Returns the controller tests corresponding to the given resource.
def controller_test(resource)
  'test/controllers/#{resource}_controller_test.rb'
end

# Returns all tests for the given resource.
def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end

guard 'livereload' do
  extensions = {
    css: :css,
    scss: :css,
    sass: :css,
    js: :js,
    coffee: :js,
    html: :html,
    png: :png,
    gif: :gif,
    jpg: :jpg,
    jpeg: :jpeg,
    # less: :less, # uncomment if you want LESS stylesheets done in browser
  }

  rails_view_exts = %w(erb haml slim)

  # file types LiveReload may optimize refresh for
  compiled_exts = extensions.values.uniq
  watch(%r{public/.+\.(#{compiled_exts * '|'})})

  extensions.each do |ext, type|
    watch(%r{
          (?:app|vendor)
          (?:/assets/\w+/(?<path>[^.]+) # path+base without extension
           (?<ext>\.#{ext})) # matching extension (must be first encountered)
          (?:\.\w+|$) # other extensions
          }x) do |m|
      path = m[1]
      "/assets/#{path}.#{type}"
    end
  end

  # file needing a full reload of the page anyway
  watch(%r{app/views/.+\.(#{rails_view_exts * '|'})$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{config/locales/.+\.yml})
end

guard 'zeus' do
  require 'ostruct'

  rspec = OpenStruct.new
  # rspec.spec_dir = 'spec'
  # rspec.spec = ->(m) { "#{rspec.spec_dir}/#{m}_spec.rb" }
  # rspec.spec_helper = "#{rspec.spec_dir}/spec_helper.rb"

  # matchers
  # rspec.spec_files = /^#{rspec.spec_dir}\/.+_spec\.rb$/

  # Ruby apps
  ruby = OpenStruct.new
  ruby.lib_files = /^(lib\/.+)\.rb$/

  # watch(rspec.spec_files)
  # watch(rspec.spec_helper) { rspec.spec_dir }
  # watch(ruby.lib_files) { |m| rspec.spec.call(m[1]) }

  # Rails example
  rails = OpenStruct.new
  rails.app_files = /^app\/(.+)\.rb$/
  rails.views_n_layouts = /^app\/(.+(?:\.erb|\.haml|\.slim))$/
  rails.controllers = %r{^app/controllers/(.+)_controller\.rb$}

  # watch(rails.app_files) { |m| rspec.spec.call(m[1]) }
  # watch(rails.views_n_layouts) { |m| rspec.spec.call(m[1]) }
  # watch(rails.controllers) do |m|
  #   [
  #     rspec.spec.call("routing/#{m[1]}_routing"),
  #     rspec.spec.call("controllers/#{m[1]}_controller"),
  #     rspec.spec.call("acceptance/#{m[1]}")
  #   ]
  # end
end
