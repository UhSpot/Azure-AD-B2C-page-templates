$subscription = "0f086dc1-a63d-477f-bdb6-163c2d5e4b6f"
$resourceGroup = "uhspot"
$storageAccount = "uhspotfiles"
$container = "root"
$expirationDate = $(get-date -AsUTC).AddMinutes(5).tostring("yyyy-MM-ddTH:mmZ")
$sourceDirectory = "/uhspot_spec/*"

#we may need this: temp
write-host ("spn - " + $env:servicePrincipalId) -ForegroundColor Yellow

az role assignment create `
    --role "Storage Blob Data Contributor" `
    --assignee javier@javier.nyc `
    --scope "/subscriptions/$($subscription)/resourceGroups/$($resourceGroup)/providers/Microsoft.Storage/storageAccounts/$($storageAccount)"

$userSas = az storage container generate-sas `
    --account-name $storageAccount `
    --name $container `
    --https-only `
    --permissions acdlrw `
    --expiry $expirationDate `
    --auth-mode login `
    --as-user
    
az storage copy -s $sourceDirectory -d https://uhspotfiles.blob.core.windows.net/root/azureb2c/template] --recursive


az storage account revoke-delegation-keys `
    --name $storageAccount `
    --resource-group $resourceGroup
