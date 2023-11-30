# frozen_string_literal: true

return unless Gem.default_path.include?(Bundler.bundle_path.to_s)

bin_dir = Gem.bindir(Bundler.bundle_path.to_s)
bins_before = File.exist?(bin_dir) ? Dir.entries(bin_dir).size : 2
Bundler::Plugin.add_hook 'after-install-all' do
  bins_after = File.exist?(bin_dir) ? Dir.entries(bin_dir).size : 2
  system 'rbenv rehash' if bins_before != bins_after
end
