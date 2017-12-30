component {
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		interceptData.timestamp = print.boldWhiteOnCyan( ' '& timeFormat( now() ) & ' >', '', true );
	}

}