@description('Deployment Environment')
@allowed([
  'dev'
  'test'
  'uat'
  'prod'
])
param env string = 'dev'

@description('Base Name of the Service Conn')
param iaConnBaseName string = ''

@description('Organization Abbreviation')
param orgAbbr string = ''

@description('Location')
param location string = resourceGroup().location


@description('Integration Acc callback url')
param callbackurl string = ''


var locationAbbr = {
  southcentralus  : 'sc'
  northcentralus : 'nc'
}

var iaConnName = 'iacon-${orgAbbr}-${locationAbbr[location]}-${toLower(iaConnBaseName)}-${env}'
var laName = 'la-${orgAbbr}-${locationAbbr[location]}-${toLower(iaConnBaseName)}-${env}'

var IAApiProvId = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/southcentralus/managedApis/x12'

param IntegrationAccName string = 'ia-${orgAbbr}-nexus-${env}' 
param  integrationAccounts_externalid  string = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Logic/integrationAccounts/${IntegrationAccName}'


resource x12Connection 'Microsoft.Web/connections@2016-06-01' = {
  name: iaConnName
  location: location
  kind: 'V2'
  properties: {
    displayName: iaConnName
    
    customParameterValues: {}
    parameterValues: {
     
      integrationAccountId: integrationAccounts_externalid
      controlNumbersBlockSize: '1000'
      integrationAccountUrl: callbackurl
    }
    
    createdTime: '2023-06-01T18:37:21.2409828Z'
    changedTime: '2024-08-07T19:55:23.756006Z'
    api: {
      name: 'IntegrationAccount'
      displayName: 'Integration Account'   
      id: IAApiProvId
      type: 'Microsoft.Web/locations/managedApis'
    }
    
  }
}

resource Integration_Account_connection_logic_app_access_policies 'Microsoft.Web/connections/accessPolicies@2016-06-01' = {
  parent: x12Connection
  name: laName
  location: resourceGroup().location  
  properties: {
    principal: {
      type: 'ActiveDirectory'
      identity: {
        tenantId: subscription().tenantId
        objectId: reference(resourceId('Microsoft.Web/sites', laName), '2019-08-01', 'full').identity.principalId
      }
    }
  }
}
