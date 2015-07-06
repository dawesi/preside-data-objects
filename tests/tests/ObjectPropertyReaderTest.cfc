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

			it( "should return an array of properties defined on an object", function(){
				var sourceFiles = [ "/resources/objectpropertyreader/object_a.cfc" ];
				var expectedResult = [
					  { "name"="label", "type"="string", "dbtype"="varchar", "maxlength"=100, "required"=true, "uniqueindexes"="title" }
					, { "name"="description", "type"="string", "dbtype"="text" }
				];

				expect( reader.readProperties( sourceFiles=sourceFiles ) ).tobe( expectedResult );
			} );

		} );

	}
}