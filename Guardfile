guard :bundler do
  watch('Gemfile')
end

# This group allows to skip running the rest when RSpec fails
group :red_green_refactor, halt_on_fail: true do
  guard :rspec,
        cmd:            'COVERAGE=false rspec --no-profile',
        failed_mode:    :none,
        all_after_pass: true,
        all_on_start:   true do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
    watch('spec/spec_helper.rb') { 'spec' }
  end

  guard :rubocop, cli: '-D' do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
