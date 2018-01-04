component {
	
	processingdirective pageEncoding='UTF-8';
	
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.gitEnable ) { return; }
		
		var CWD = fileSystem.resolvePath( '' );
		var repoPath = CWD & '/.git';
		
		/*
		TODO:  
		plus for files added on stage
		many point start for modified files
		X for delete files on stage???
		5 point start for untracked files
		equals sign for unmerged state?
		up arrow for ahead state from remote
		down arrow for behind state from remote
		up/down arrow for diverged state from remote
		*/
		
		try {
	
			if( directoryExists( repoPath ) ) {
				var unicode = interceptData.settings.unicode;
				
				var GitAPI = createObject( 'java', 'org.eclipse.jgit.api.Git' );
				var git = GitAPI.open( createObject( 'java', 'java.io.File' ).init( repoPath ) );
				var branchName = git.getRepository().getBranch();
				
				var repoStatus = git.status().call();
				var isClean = repoStatus.isClean();
				var hasAdded = arrayLen( repoStatus.getAdded() );
				var hasConflicting = arrayLen( repoStatus.getConflicting() );
				var hasChanged = arrayLen( repoStatus.getChanged() );
				var hasMissing = arrayLen( repoStatus.getMissing() );
				var hasModified = arrayLen( repoStatus.getModified() );
				var hasRemoved = arrayLen( repoStatus.getRemoved() );
				var hasUnCommittedChanges = arrayLen( repoStatus.getUncommittedChanges() );
				var hasUntracked = arrayLen( repoStatus.getUntracked() );
				var hasUntrackedFolders = arrayLen( repoStatus.getUntrackedFolders() );
				// repoStatus.getConflictingStageState();
				
			/*	systemoutput( 'isClean: ' & isClean, 1 )
				systemoutput( 'hasAdded: ' & hasAdded, 1 )
				systemoutput( 'hasConflicting: ' & hasConflicting, 1 )
				systemoutput( 'hasChanged: ' & hasChanged, 1 )
				systemoutput( 'hasMissing: ' & hasMissing, 1 )
				systemoutput( 'hasRemoved: ' & hasRemoved, 1 )
				systemoutput( 'hasModified: ' & hasModified, 1 )
				systemoutput( 'hasUnCommittedChanges: ' & hasUnCommittedChanges, 1 )
				systemoutput( 'hasUntracked: ' & hasUntracked, 1 )
				systemoutput( 'hasUntrackedFolders: ' & hasUntrackedFolders, 1 )*/
				
				var backgroundColor = isClean ? interceptData.settings.gitCleanBG : interceptData.settings.gitDirtyBG;
				
				var statusText = '';
				if( unicode ) {
					statusText &= '➽ ';
				}
				statusText &= 'branchName ';
				
				// file added but not staged
				if( hasUntracked ) {
					statusText &= ' +#hasUntracked#';					
				}				
				// File mofied but not staged
				if( hasModified ) {
					statusText &= ' ~#hasModified#';					
				}				
				// File deleted by not staged
				if( hasMissing ) {
					statusText &= ' -#hasMissing#';					
				}
				
				// Staged removal and addition
				if( hasAdded && hasRemoved ) {
					statusText &= ' ' & ( unicode ? '±' : '+/-' );
				// Staged addition
				} else if ( hasAdded ) {
					statusText &= ' ' & ( unicode ? '＋' : '+' );
				// Staged removal
				} else if ( hasRemoved ) {
					statusText &= ' ' & ( unicode ? '－' : '-' );
				// Staged modification
				}else if ( hasChanged ) {
					statusText &= ' ' & ( unicode ? '~' : '~' );
				}
				
				interceptData.cars.git.text = print.text( ' ' & statusText & ' ', '#interceptData.settings.gitText#on#backgroundColor#' );
					
				interceptData.cars.git.background = backgroundColor;
			}
			
		} catch( any var e ) {
			interceptData.cars.git.text = 'Git car: ' & e.message;
			interceptData.cars.git.background = 'black';
		} finally {
			
			// Release file system locks on the repo
			if( structKeyExists( local, 'git' ) ) {
				git.getRepository().close();
				git.close();
			}
		}
		
	}

}