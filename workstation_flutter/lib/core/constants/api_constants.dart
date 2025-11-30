class WorkstationApiConstants{

static final String baseUrl = "https://workstation-arqui-fgbngphuh0g4a8at.canadacentral-01.azurewebsites.net";
static final String registerEndpoint = "/api/workstation/User/sign-up";
static final String loginEndpoint = "/api/workstation/User/login";
static final String getUserById = "/api/workstation/User/{id}";
static final String officesEndpoint = "/api/workstation/Office";
static final String officeByIdEndpoint = "/api/workstation/Office/{id}";
static final String officeByLocationEndpoint = "/api/workstation/Office/by-location/{id}";
static final String updateOfficeByIdEndpoint = "/api/workstation/Office/{id}";
static final String createContractEndpoint = "/api/workstation/Contracts";
static final String addClauseEndpoint = "/api/workstation/Contracts/{contractId}/clauses";
static final String addSignatureEndpoint = "/api/workstation/Contracts/{contractId}/signatures";
static final String activateContractEndpoint = "/api/workstation/Contracts/{contractId}/activate";
static final String getContractEnpoint = "/api/workstation/Contracts/user/{userId}";
static final String getAllActiveContractsEndpoint = "/api/workstation/Contracts/active";
}

// https://workstation-arqui-fgbngphuh0g4a8at.canadacentral-01.azurewebsites.net/api/workstation/User/login