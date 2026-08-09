# Laboratory Metrics Dashboard

This dashboard is generated from repository data and is limited to the controlled lab. It must not be read as production performance, customer experience or hiring probability.

Run:

```powershell
.\powershell\New-LabMetricsReport.ps1 -OutputPath .\reports\lab-metrics.json -CsvPath .\reports\lab-metrics.csv
```

The generated JSON and CSV are the current machine-readable sources. The methodology is documented in [`metrics-methodology.md`](metrics-methodology.md).

