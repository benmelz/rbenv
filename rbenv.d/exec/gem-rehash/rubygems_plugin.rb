hook = lambda do |installer|
  begin
    # Ignore gems that aren't installed in locations that rbenv searches for binstubs
    if installer.spec.executables.any? &&
        [Gem.default_bindir, Gem.bindir(Gem.user_dir)].include?(installer.bin_dir)
      `rbenv rehash`
    end
  rescue
    warn "rbenv: error in gem-rehash (#{$!.class.name}: #{$!.message})"
  end
end

begin
  if defined?(Bundler::Plugin)
    Bundler::Plugin.send :register_plugin,
                         'gem-rehash',
                         Struct.new(:full_gem_path, :load_paths).new(File.expand_path(__dir__), [])
  else
    Gem.post_install(&hook)
    Gem.post_uninstall(&hook)
  end
rescue StandardError => e
  warn "rbenv: error installing gem-rehash hooks (#{e.class.name}: #{e.message})"
end

