component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		var reader = new presidedataobjects.library.ObjectPropertyReader();

		describe( "readProperties()", function(){
			it( "should return an empty array of properties passed an empty array of filepaths", function(){
				expect( reader.readProperties( sourceFiles=[] ) ).tobe( [] );
			} );
		} );

	}
}