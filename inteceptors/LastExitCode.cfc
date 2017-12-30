component {
	property name='shell' inject='shell';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		var exitCode = shell.getExitCode();
		interceptData.lastExitCode = ' ' & ( exitCode == 0 ? print.boldGreen( 'Success' ) : print.boldRed( 'Failure' ) ) & ' >';
	}

}