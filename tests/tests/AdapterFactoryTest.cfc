component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "getAdapter()", function(){
			it( "should return the MySqlAdapter when the passed datasource is for a MySql 5+ datasource", function(){
				var factory = _getFactory();
				var dsn     = "somemadeupdsn";

				mockDbInfoService.$( "getDatabaseVersion" ).$args( dsn ).$results( QueryNew( "database_productname", "varchar", [ [ "MySql" ] ] ) );

				var adapter = factory.getAdapter( dsn );

				expect( adapter ).toBeInstanceOf( "MySqlAdapter" );

			} );

			it( "should throw an informative error when the passed datasource does not exist", function(){
				var factory = _getFactory();
				var dsn     = "somemadeupdsn";

				mockDbInfoService.$( "getDatabaseVersion" ).$args( dsn ).$results( QueryNew( "database_productname", "varchar" ) );

				expect( function(){
					factory.getAdapter( dsn )
				} ).toThrow( "PresideObjects.datasourceNotFound" );
			} );

			it( "should throw an informative error when the passed datasource is not a database engine that we currently support", function(){
				var factory = _getFactory();
				var dsn     = "somemadeupdsn";

				mockDbInfoService.$( "getDatabaseVersion" ).$args( dsn ).$results( QueryNew( "database_productname", "varchar", [ [ "MSSQL" ] ] ) );

				expect( function(){
					factory.getAdapter( dsn )
				} ).toThrow( "PresideObjects.databaseEngineNotSupported" );
			} );
		} );
	}

	private any function _getFactory() {
		variables.mockDbInfoService = getMockbox().createStub();

		return getMockbox().prepareMock(
			object = new presidedataobjects.db.adapter.AdapterFactory( dbInfoService=mockDbInfoService )
		);
	}
}