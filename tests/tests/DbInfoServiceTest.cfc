component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.testDsn = "anyolddsn";
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "tableExists()", function(){
			it( "should return false when getTableInfo() returns an empty recordset", function(){
				var service   = _getInfoService();
				var tablename = CreateUUId();

				service.$( "getTableInfo").$args( tablename=tablename, dsn=testDsn ).$results( QueryNew( '' ) );

				expect( service.tableExists( tablename=tablename, dsn=testDsn ) ).toBe( false );
			} );

			it( "should return true when getTableInf() returns one or more records for the given table", function(){
				var service   = _getInfoService();
				var tablename = CreateUUId();

				service.$( "getTableInfo").$args( tablename=tablename, dsn=testDsn ).$results( QueryNew( 'test', 'varchar', [[CreateUUId()]] ) );

				expect( service.tableExists( tablename=tablename, dsn=testDsn ) ).toBe( true );
			} );

		} );
	}


/*********************************** PRIVATE HELPERS ***********************************/
	private any function _getInfoService() {
		var service = new presidedataobjects.db.DbInfoService();

		return getMockbox().createMock( object=service );
	}

}