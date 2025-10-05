
-- Stop the trace
DECLARE @TraceID int = 2; --Replace with correct TraceID if necessary
EXEC sp_trace_setstatus @TraceID, 0;
EXEC sp_trace_setstatus @TraceID, 2;
GO

-- View the trace
SELECT * FROM fn_trace_gettable('D:\Demofiles\Mod08\SQLTraceDemo.trc', default);