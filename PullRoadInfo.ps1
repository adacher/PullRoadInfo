# Show detailed information for each node used to reach a dns provided as a parameter.
Param ([parameter(mandatory=$true)][string]$dnsname)
function PullRoadInfo {
    Get-date
    Write-Output $dnsname
    $road       = Test-NetConnection $dnsname -TraceRoute
    [int]$count = 1
    foreach ($hop in $road.TraceRoute)
    {
        if ($hop -ne "0.0.0.0" -and $hop -ne "192.168.0.1")
        {
            # Api used to gather data about each node.
            $details         = Invoke-RestMethod -Method Get -Uri "http://geoip.nekudo.com/api/$hop"
            [string]$display = "$count)"
            Write-Output $display
            [PSCustomObject]@{
               IP            = $details.IP
               City          = $details.City
               Country       = $details.Country.Name
               Code          = $details.Country.Code
               Location      = $details.Location.Latitude
               Longitude     = $details.Location.Longitude
               TimeZone      = $details.Location.Time_zone
            }
            $count++
        }
    }
}
Resolve-DnsName $dnsname
# Function > Custom path.
PullRoadInfo > D:\prog\powershell\Network\PullRoadInfo\Output\Hops.txt