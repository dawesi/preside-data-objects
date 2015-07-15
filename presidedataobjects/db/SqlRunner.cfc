/**
 * Class that abstracts logic for running SQL against a datasource
 *
 */
component {

	/**
	 * Constructor
	 *
	 * @logger.hint Logger object that is used for debugging SQL run, etc.
	 *
	 */
	public any function init( required any logger ) {
		_setLogger( arguments.logger );

		return this;
	}

// PUBLIC API METHODS
	/**
	 * Runs the given SQL and returns either a recordset or details
	 * of the result
	 *
	 * @sql.hint        The SQL to run
	 * @dsn.hint        The datasource to run the SQL against. Can be either named datasource (string) or structure containing connection info
	 * @params.hint     Array of query params. Each params is a struct with attributes those of cfqueryparam
	 * @returntype.hint Either 'recordset' to return the records from a select query, or 'info', to return a struct with information about the result of other query types
	 */
	public any function runSql(
		  required string sql
		, required string dsn
		,          array  params
		,          string returntype="recordset"
	) output=false {
		var q      = _newQuery();
		var logger = _getLogger();

		if ( logger.canDebug() ) { logger.debug( "Running SQL against datasource [#arguments.dsn#]: [#arguments.sql#]" ); }

		q.setDatasource( arguments.dsn );
		q.setSQL( arguments.sql );

		if ( StructKeyExists( arguments, "params" ) ) {
			for( param in arguments.params ){
				param.value     = param.value ?: "";
				param.cfsqltype = param.cfsqltype ?: "";

				if ( not IsSimpleValue( param.value ) ) {
					throw(
						  type = "SqlRunner.BadParam"
						, message = "SQL Param values must be simple values"
						, detail = "The value of the param, [#param.name#], was not of a simple type"
					);
				}

				if ( Len( Trim( param.type ?: "" ) ) ) {
					param.cfsqltype = param.type; // mistakenly had thought we could do param.type - alas no, so need to fix it to the correct argument name here
					param.delete( "type" );
				}

				if ( param.cfsqltype eq 'cf_sql_bit' and not IsNumeric( param.value ) ) {
					param.value = IsBoolean( param.value ) and param.value ? 1 : 0;
				}

				if ( not Len( Trim( param.value ) ) ) {
					param.null = true;
				}


				q.addParam( argumentCollection = param );
			}
		}
		result = q.execute();

		if ( arguments.returntype eq "info" ) {
			return result.getPrefix();
		} else {
			return result.getResult();
		}
	}

// PRIVATE HELPERS
	private any function _newQuery() {
		return new Query();
	}

// GETTERS AND SETTERS
	private any function _getLogger() {
		return _logger;
	}
	private void function _setLogger( required any logger ) {
		_logger = arguments.logger;
	}
}