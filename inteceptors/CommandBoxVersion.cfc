component {
	property name='shell' inject='shell';
	property name='semanticVersion'		inject='provider:semanticVersion@semver';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		var version = semanticVersion.parseVersion( shell.getVersion().replace( '@build.version@+@build.number@', '1.2.3+12345' ) );
		interceptData.commandboxVersion = print.blackOnYellow( ' CommandBox v' & version.major & '.' & version.minor & '.' & version.revision & ' >' );
	}

}