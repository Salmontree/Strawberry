{ pkgs, lib, config, inputs, ... }:

{
	languages.odin.enable = true;

	languages.java = {
		enable = true;
		jdk.package = pkgs.jdk8;
		gradle.enable = false;
	};

	packages = [
		pkgs.sdl3
		pkgs.vulkan-loader
	];

	env.LD_LIBRARY_PATH = lib.makeLibraryPath [
		pkgs.vulkan-loader
	];

	scripts.build-debug.exec = ''
		odin build src -out:build/debug/strawberry -debug -extra-linker-flags:"-L${pkgs.sdl3}/lib" -collection:lib=lib -collection:src=src
	'';
	scripts.build-release.exec = ''
		odin build src -out:build/release/strawberry-macos-amd64 -o:aggressive -target:"darwin_amd64" -extra-linker-flags:"-L${pkgs.sdl3}/lib" -collection:lib=lib -collection:src=src
		odin build src -out:build/release/strawberry-linux-amd64 -o:aggressive -target:"linux_amd64" -extra-linker-flags:"-L${pkgs.sdl3}/lib" -collection:lib=lib -collection:src=src
		odin build src -out:build/release/strawberry-windows-amd64.exe -o:aggressive -target:"windows_amd64" -extra-linker-flags:"-L${pkgs.sdl3}/lib" -collection:lib=lib -collection:src=src
	'';

	scripts.run.exec = ''
		if build-debug; then
			./build/debug/strawberry
		fi
	'';
}
