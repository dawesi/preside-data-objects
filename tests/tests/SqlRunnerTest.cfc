component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "runSql()", function(){

			it( "should log passed sql and dsn when logger is allowed to debug", function(){
				var runner = _getRunner();
				var dummySql = "select * from mytable";
				var dummyDsn = "mydbconnection";

				mockLogger.$( "canDebug", true );

				runner.runSql( sql=dummySql, dsn=dummyDsn );

				var debugLog = mockLogger.$callLog().debug;
				expect( debugLog.len() ).toBe( 1 );
				expect( debugLog[1] ).toBe( [ "Running SQL against datasource [#dummyDsn#]: [#dummySql#]" ] );
			} );

			it( "should not log anything when logger does not allow debug messages", function(){
				var runner = _getRunner();
				var dummySql = "select * from mytable";
				var dummyDsn = "mydbconnection";

				mockLogger.$( "canDebug", false );

				runner.runSql( sql=dummySql, dsn=dummyDsn );

				var debugLog = mockLogger.$callLog().debug;
				expect( debugLog.len() ).toBe( 0 );
			} );

			it( "should set the passed datasource on the query object", function(){
				var runner = _getRunner();
				var dummySql = "select * from mytable";
				var dummyDsn = "mydbconnection";

				runner.runSql( sql=dummySql, dsn=dummyDsn );

				var setDatasourceLog = mockQuery.$callLog().setDatasource;
				expect( setDatasourceLog.len() ).toBe( 1 );
				expect( setDatasourceLog[1] ).toBe( [ dummyDsn ] );
			} );

			it( "should set the passed SQL on the query object", function(){
				var runner = _getRunner();
				var dummySql = "select * from mytable";
				var dummyDsn = "mydbconnection";

				runner.runSql( sql=dummySql, dsn=dummyDsn );

				var setSqlLog = mockQuery.$callLog().setSql;
				expect( setSqlLog.len() ).toBe( 1 );
				expect( setSqlLog[1] ).toBe( [ dummySql ] );
			} );

			it( "should execute the query", function(){
				var runner = _getRunner();
				var dummySql = "select * from mytable";
				var dummyDsn = "mydbconnection";

				runner.runSql( sql=dummySql, dsn=dummyDsn );

				var executeLog = mockQuery.$callLog().execute;
				expect( executeLog.len() ).toBe( 1 );
			} );

			it( "should return the query result of sql execution by default", function(){
				var runner           = _getRunner();
				var dummySql         = "select * from mytable";
				var dummyDsn         = "mydbconnection";
				var dummyQueryResult = Querynew( 'id', 'varchar', [ [ CreateUUId() ] ] );

				mockResult.$( "getResult", dummyQueryResult );

				var result = runner.runSql( sql=dummySql, dsn=dummyDsn );

				expect( result ).toBe( dummyQueryResult );
			} );

			it( "should return SQL run info when returntype passed as 'info'", function(){
				var runner    = _getRunner();
				var dummySql  = "select * from mytable";
				var dummyDsn  = "mydbconnection";
				var dummyInfo = { timetaken=485, teat=true };

				mockResult.$( "getPrefix", dummyInfo );

				var result = runner.runSql( sql=dummySql, dsn=dummyDsn, returntype="info" );

				expect( result ).toBe( dummyInfo );
			} );

			it( "should add each individual passed param to the query object before execution", function(){
				var runner    = _getRunner();
				var dummySql  = "select * from mytable";
				var dummyDsn  = "mydbconnection";
				var dummyParams = [
					  { name="test1", value=1351   , cfsqltype="int"     }
					, { name="test2", value="test2", cfsqltype="varchar" }
				];

				runner.runSql( sql=dummySql, dsn=dummyDsn, params=dummyParams );

				var addParamLog = mockQuery.$callLog().addParam;
				expect( addParamLog.len() ).toBe( dummyParams.len() );
				for( var i=1; i <= dummyParams.len(); i++ ) {
					expect( addParamLog[i] ).toBe( dummyParams[i] );
				}
			} );

			it( "should throw an informative error when a passed param contains a complex value for its value element", function(){
				var runner    = _getRunner();
				var dummySql  = "select * from mytable";
				var dummyDsn  = "mydbconnection";
				var dummyParams = [
					  { name="test1", value={ test="me" } }
				];

				expect( function(){
					runner.runSql( sql=dummySql, dsn=dummyDsn, params=dummyParams );
				} ).toThrow( "SqlRunner.BadParam" );
			} );

			it( "should set the param as NULL when the value is an empty string", function(){
				var runner    = _getRunner();
				var dummySql  = "select * from mytable";
				var dummyDsn  = "mydbconnection";
				var dummyParams = [
					  { name="test1", value="", cfsqltype="cf_sql_varchar" }
				];

				runner.runSql( sql=dummySql, dsn=dummyDsn, params=dummyParams );

				var addParamLog = mockQuery.$callLog().addParam;
				expect( addParamLog.len() ).toBe( 1 );
				expect( addParamLog[1] ).toBe( { name="test1", value="", null=true, cfsqltype="cf_sql_varchar" } );
			} );

			it( "should set convert a type attribute in params to be cfsqltype", function(){
				var runner    = _getRunner();
				var dummySql  = "select * from mytable";
				var dummyDsn  = "mydbconnection";
				var dummyParams = [
					  { name="test1", value="test", type="varchar" }
				];

				runner.runSql( sql=dummySql, dsn=dummyDsn, params=dummyParams );

				var addParamLog = mockQuery.$callLog().addParam;
				expect( addParamLog.len() ).toBe( 1 );
				expect( addParamLog[1] ).toBe( { name="test1", value="test", cfsqltype="varchar" } );
			} );

			it( "should set value to 0 for empty string values when cfsqltype is 'cf_sql_bit'", function(){
				var runner    = _getRunner();
				var dummySql  = "select * from mytable";
				var dummyDsn  = "mydbconnection";
				var dummyParams = [
					  { name="test1", value="", cfsqltype="cf_sql_bit" }
				];

				runner.runSql( sql=dummySql, dsn=dummyDsn, params=dummyParams );

				var addParamLog = mockQuery.$callLog().addParam;
				expect( addParamLog.len() ).toBe( 1 );
				expect( addParamLog[1] ).toBe( { name="test1", value="0", cfsqltype="cf_sql_bit" } );
			} );

		} );
	}

/*********************************** PRIVATE HELPERS ***********************************/

	private any function _getRunner() {
		variables.mockResult = getMockBox().createStub();
		variables.mockResult.$( "getPrefix", {} );
		variables.mockResult.$( "getResult", QueryNew( '' ) );

		variables.mockQuery  = getMockBox().createStub();
		variables.mockQuery.$( "setDatasource" );
		variables.mockQuery.$( "setSql" );
		variables.mockQuery.$( "addParam" );
		variables.mockQuery.$( "execute", mockResult );

		variables.mockLogger = getMockBox().createStub();
		variables.mockLogger.$( "canDebug", false );
		variables.mockLogger.$( "debug" );
		variables.mockLogger.$( "canInfo" , false );
		variables.mockLogger.$( "info"  );
		variables.mockLogger.$( "canWarn" , false );
		variables.mockLogger.$( "warn"  );
		variables.mockLogger.$( "canError", false );
		variables.mockLogger.$( "error" );
		variables.mockLogger.$( "canFatal", false );
		variables.mockLogger.$( "fatal" );

		var runner = getMockBox().prepareMock( object=new presidedataobjects.db.SqlRunner( logger=mockLogger ) );

		runner.$( "_newQuery", mockQuery );

		return runner;
	}
}
