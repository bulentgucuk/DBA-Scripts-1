-------------------------------------------------------
-- TRACE DEFINITION FOR ERROR TRAPPING DURING REPLAY --
-------------------------------------------------------

SET NOCOUNT ON;

-- Create a Queue
DECLARE @rc int
DECLARE @TraceID int
DECLARE @maxfilesize bigint
DECLARE @hostName nvarchar(255)

SELECT @maxfilesize = 500, @hostName = host_name()



BEGIN TRY
	EXEC @rc = sp_trace_create @TraceID output, 0, N'$(TraceFileName)', @maxfilesize, NULL 
	if (@rc != 0) RAISERROR('Unable to start the trace',16,1)

	-- Set the events
	DECLARE @on bit
	set @on = 1
	EXEC sp_trace_setevent @TraceID, 162, 7,  @on
	EXEC sp_trace_setevent @TraceID, 162, 31, @on
	EXEC sp_trace_setevent @TraceID, 162, 8,  @on
	EXEC sp_trace_setevent @TraceID, 162, 64, @on
	EXEC sp_trace_setevent @TraceID, 162, 1,  @on
	EXEC sp_trace_setevent @TraceID, 162, 9,  @on
	EXEC sp_trace_setevent @TraceID, 162, 41, @on
	EXEC sp_trace_setevent @TraceID, 162, 49, @on
	EXEC sp_trace_setevent @TraceID, 162, 6,  @on
	EXEC sp_trace_setevent @TraceID, 162, 10, @on
	EXEC sp_trace_setevent @TraceID, 162, 14, @on
	EXEC sp_trace_setevent @TraceID, 162, 26, @on
	EXEC sp_trace_setevent @TraceID, 162, 30, @on
	EXEC sp_trace_setevent @TraceID, 162, 50, @on
	EXEC sp_trace_setevent @TraceID, 162, 66, @on
	EXEC sp_trace_setevent @TraceID, 162, 3,  @on
	EXEC sp_trace_setevent @TraceID, 162, 11, @on
	EXEC sp_trace_setevent @TraceID, 162, 35, @on
	EXEC sp_trace_setevent @TraceID, 162, 51, @on
	EXEC sp_trace_setevent @TraceID, 162, 4,  @on
	EXEC sp_trace_setevent @TraceID, 162, 12, @on
	EXEC sp_trace_setevent @TraceID, 162, 20, @on
	EXEC sp_trace_setevent @TraceID, 162, 60, @on


	-- Set the Filters
	DECLARE @intfilter int
	DECLARE @bigintfilter bigint

	EXEC sp_trace_setfilter @TraceID, 1, 0, 7, N'Changed database context%'
	EXEC sp_trace_setfilter @TraceID, 1, 0, 7, N'Changed language setting%'
	EXEC sp_trace_setfilter @TraceID, 8, 0, 6, @hostName
	-- Set the trace status to start
	EXEC sp_trace_setstatus @TraceID, 1

	-- display trace id for future references
	SELECT TraceID=@TraceID

END TRY
BEGIN CATCH
	DECLARE @ErrNum int, @ErrMsg nvarchar(4000);
	SELECT @ErrNum = ERROR_NUMBER(), @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg, @ErrNum, 3);
END CATCH
