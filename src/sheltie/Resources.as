// ActionScript file

package sheltie {
	internal class Resources extends ResourceBundle {
		[Embed(source = 'resources/images/chars1.png')]
			public const chars1_png:Class;

		[Embed(source = 'resources/images/items.png')]
			public const items_png:Class;

		[Embed(source = 'resources/images/markers.png')]
			public const markers_png:Class;

		[Embed(source = 'resources/images/tiles.png')]
			public const tiles_png:Class;

		[Embed(source = 'resources/images/tileset1.png')]
			public const tileset1_png:Class;

		[Embed(source = 'resources/levels/bender.sheltie', mimeType="application/octet-stream")]
			public const bender_sheltie:Class;

		[Embed(source = 'resources/objects/common.json', mimeType="application/octet-stream")]
			public const common_json:Class;
	}
}