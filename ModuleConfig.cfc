component {
	
	function configure() {
		
		settings = {
			// Turn the entire module on/off
			'enable' : true
		};
		
		interceptorSettings = {
		    customInterceptionPoints = "onBulletTrain"
		};
		
		var files = directoryList( expandPath( modulePath & '/inteceptors' ) );
		
		interceptors = []
		files.each( function( i ) {
			interceptors.append( {
				class : moduleMapping & '.inteceptors.' & i.listLast( '\/' ).listFirst( '.' )
			} );
		} );
		
	}
		
	
    function prePrompt( interceptData ) {
    	if( !settings.enable ) {
    		return;
    	}
 
		var interceptorService = wirebox.getInstance( dsl='interceptorService' );
		   	
    	var myData = {};
    	interceptorService.announceInterception( 'onBulletTrain', myData );
    	
    	var prompt = '';
    	for( var p in myData ) {
    		prompt &= myData[ p ];
    	}
    	interceptData.prompt = prompt & chr( 10 ) & '> ';
        
    }
    
}