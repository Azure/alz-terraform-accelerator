{
    "lenses": {
        "0": {
            "order": 0,
            "parts": {
                "0": {
                    "metadata": {
                        "inputs": [],
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "<div>\r\n  <div>\r\n    <ul>\r\n      <li>\r\n        <a href='https://aka.ms/sovereign-landing-zone'>Sovereign Landing Zone GitHub Landing Page</a>\r\n      </li>\r\n      <li>\r\n        <a href='https://learn.microsoft.com/industry/sovereignty/'>More information about Sovereign Landing Zone and the Microsoft Cloud for Sovereignty</a>\r\n      </li>\r\n      <li>\r\n        <a href='https://aka.ms/sovereign-landing-zone/docs/12-FAQ.md'>Frequently Asked Questions</a>\r\n      </li>\r\n      <li>\r\n        <a href='https://aka.ms/sovereign-landing-zone/docs/10-Compliance-Dashboard.md'>Information on Sovereign Landing Zone Dashboard</a>\r\n      </li>\r\n    </ul>\r\n  </div>\r\n</div>\r\n",
                                    "markdownSource": 1,
                                    "markdownUri": null,
                                    "subtitle": "${customer}",
                                    "title": "Sovereign landing zone dashboard"
                                }
                            }
                        },
                        "type": "Extension/HubsExtension/PartType/MarkdownPart"
                    },
                    "position": {
                        "colSpan": 8,
                        "rowSpan": 2,
                        "x": 0,
                        "y": 0
                    }
                },
                "1": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Overall resources compliance score"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates' and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), resourceType = tolower(properties.resourceType), stateWeight = tolong(properties.stateWeight)\r\n| summarize maxStateWeight =  max(stateWeight) by resourceId, resourceType\r\n| project resourceId, resourceType,\r\n    complianceState = case(\r\n            maxStateWeight == 300, \"NonCompliant\",\r\n            maxStateWeight == 200, \"Compliant\",\r\n            maxStateWeight == 100, \"Conflict\",\r\n            maxStateWeight == 50, \"Exempt\",\r\n             \"UnknownResource\"\r\n         )\r\n| summarize counts = count() by complianceState\r\n| summarize compliantCount = sumif(counts, complianceState == 'Compliant' or complianceState == 'Exempt'), nonCompliantCount = sumif(counts, complianceState == 'Conflict' or complianceState == 'NonCompliant')\r\n| extend totalNum = toint(compliantCount + nonCompliantCount)\r\n| extend compliancePercentageVal = iff(totalNum == 0, todouble(100), 100 * todouble(compliantCount) / totalNum)\r\n| project ['Compliance percentage (includes compliant and exempt)'] = strcat(tostring(round(compliancePercentageVal, 1)), '% (', tostring(compliantCount),' out of ', tostring(totalNum), ')')\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Percent of resources compliant with all policies",
                            "title": "Overall resources compliance score"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQuerySingleValueTile"
                    },
                    "position": {
                        "colSpan": 8,
                        "rowSpan": 2,
                        "x": 8,
                        "y": 0
                    }
                },
                "2": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Overall data residency compliance score"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates' and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend policyDefinitionId = tostring(properties.policyDefinitionId), policyGroups = tolower(properties.policyDefinitionGroupNames)\r\n| mv-expand parsed_policy_groups = parse_json(policyGroups)\r\n| where tostring(parsed_policy_groups) == \"so.1 - data residency\"\r\n| extend complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), resourceType = tolower(properties.resourceType), stateWeight = tolong(properties.stateWeight)\r\n| summarize max(stateWeight) by resourceId, resourceType\r\n| project resourceId, resourceType, complianceState = iff(max_stateWeight == 300, 'NonCompliant', iff(max_stateWeight == 200, 'Compliant', iff(max_stateWeight == 100 , 'Conflict', iff(max_stateWeight == 50, 'Exempt', 'UnknownResource'))))\r\n| summarize counts = count() by complianceState\r\n| summarize compliantCount = sumif(counts, complianceState == 'Compliant' or complianceState == 'Exempt'), nonCompliantCount = sumif(counts, complianceState == 'Conflict' or complianceState == 'NonCompliant')\r\n| extend totalNum = toint(compliantCount + nonCompliantCount)\r\n| extend compliancePercentageVal = iff(totalNum == 0, todouble(100), 100 * todouble(compliantCount) / totalNum)\r\n| project ['Data residency compliance percentage (includes compliant and exempt)'] = strcat(tostring(round(compliancePercentageVal, 1)), '% (', tostring(compliantCount),' out of ', tostring(totalNum), ')')\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Percent of resources compliant with data residency policies",
                            "title": "Overall data residency compliance score"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQuerySingleValueTile"
                    },
                    "position": {
                        "colSpan": 8,
                        "rowSpan": 2,
                        "x": 0,
                        "y": 2
                    }
                },
                "3": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Overall confidential compliance score"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n|where type == 'microsoft.policyinsights/policystates' and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend policyDefinitionId = tolower(properties.policyDefinitionId), policyGroups = tolower(properties.policyDefinitionGroupNames)\r\n| mv-expand parsed_policy_groups = parse_json(policyGroups)\r\n| where tostring(parsed_policy_groups) in (\"so.3 - customer-managed keys\", \"so.4 - azure confidential computing\")\r\n| project properties, policyDefinitionId, tostring(parsed_policy_groups)\r\n| extend complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), resourceType = tolower(properties.resourceType), stateWeight = tolong(properties.stateWeight)\r\n| summarize max(stateWeight) by resourceId, resourceType\r\n| project resourceId, resourceType, complianceState = iff(max_stateWeight == 300, 'NonCompliant', iff(max_stateWeight == 200, 'Compliant', iff(max_stateWeight == 100 , 'Conflict', iff(max_stateWeight == 50, 'Exempt', 'UnknownResource'))))\r\n| summarize counts = count() by complianceState\r\n| summarize compliantCount = sumif(counts, complianceState == 'Compliant' or complianceState == 'Exempt'), nonCompliantCount = sumif(counts, complianceState == 'Conflict' or complianceState == 'NonCompliant')\r\n| extend totalNum = toint(compliantCount + nonCompliantCount)\r\n| extend compliancePercentageVal = iff(totalNum == 0, todouble(100), 100 * todouble(compliantCount) / totalNum)\r\n| project ['Confidentiality compliance percentage (includes compliant and exempt)'] = strcat(tostring(round(compliancePercentageVal, 1)), '% (', tostring(compliantCount),' out of ', tostring(totalNum), ')')\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Percent of resources compliant with encryption and confidential computing policies",
                            "title": "Overall confidential compliance score"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQuerySingleValueTile"
                    },
                    "position": {
                        "colSpan": 8,
                        "rowSpan": 2,
                        "x": 8,
                        "y": 2
                    }
                },
                "4": {
                    "metadata": {
                        "inputs": [],
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "",
                                    "markdownSource": 1,
                                    "markdownUri": null,
                                    "subtitle": "",
                                    "title": "Policy compliance"
                                }
                            }
                        },
                        "type": "Extension/HubsExtension/PartType/MarkdownPart"
                    },
                    "position": {
                        "colSpan": 16,
                        "rowSpan": 1,
                        "x": 0,
                        "y": 4
                    }
                },
                "5": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resource compliance by state"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates' and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), stateWeight = tolong(properties.stateWeight)\r\n| summarize max(stateWeight) by resourceId\r\n| project resourceId, complianceState = iff(max_stateWeight == 300, 'NonCompliant', iff(max_stateWeight == 200, 'Compliant', iff(max_stateWeight == 100 , 'Conflict', iff(max_stateWeight == 50, 'Exempt', 'Unknown'))))\r\n| summarize counts = count() by complianceState\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "chartType",
                                "value": 2
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Hover over bar to see percent of resources in each state",
                            "title": "Resource compliance by state"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryChartTile"
                    },
                    "position": {
                        "colSpan": 6,
                        "rowSpan": 8,
                        "x": 0,
                        "y": 5
                    }
                },
                "6": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resource compliance percentage by subscription"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates'\r\n| extend policyAssignmentScope = tolower(properties.policyAssignmentScope)\r\n| where policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and policyAssignmentScope endswith ''\r\n| extend complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId),subscriptionId = tostring(properties.subscriptionId), stateWeight = tolong(properties.stateWeight)\r\n| summarize max(stateWeight) by resourceId, subscriptionId\r\n| join kind=inner (\r\n    resourcecontainers\r\n    | where type == 'microsoft.resources/subscriptions'\r\n    | project subscriptionId, subscriptionName = name\r\n  ) on subscriptionId\r\n| summarize counts = count() by subscriptionId, subscriptionName, max_stateWeight\r\n| summarize nonCompliantCount = sumif(counts, max_stateWeight == 300), compliantCount = sumif(counts, max_stateWeight == 200), conflictCount = sumif(counts, max_stateWeight == 100), exemptCount = sumif(counts, max_stateWeight == 50) by subscriptionId, subscriptionName\r\n| extend totalResources = todouble(nonCompliantCount + compliantCount + conflictCount + exemptCount)\r\n| extend totalCompliantResources = todouble(compliantCount + exemptCount)\r\n| extend compliancePercentage = iff(totalResources == 0 or (totalCompliantResources == 0 and nonCompliantCount == 0), todouble(100), 100 * totalCompliantResources / totalResources)\r\n| project subscriptionName, compliancePercentageEx = toint(round(compliancePercentage, 1))\r\n| order by compliancePercentageEx asc\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "chartType",
                                "value": 1
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Hover over bar to see subscription name and its compliance percentage",
                            "title": "Resource compliance percentage by subscription"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryChartTile"
                    },
                    "position": {
                        "colSpan": 10,
                        "rowSpan": 4,
                        "x": 6,
                        "y": 5
                    }
                },
                "7": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resource compliance percentage by policy initiative"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates' and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend  policySetInitiative = tostring(properties.policySetDefinitionName), resourceId = tolower(properties.resourceId), stateWeight = tolong(properties.stateWeight)\r\n| summarize max(stateWeight) by resourceId, policySetInitiative\r\n| summarize counts = count() by policySetInitiative, max_stateWeight\r\n| summarize nonCompliantCount = sumif(counts, max_stateWeight == 300), compliantCount = sumif(counts, max_stateWeight == 200),  conflictCount = sumif(counts, max_stateWeight == 100), exemptCount = sumif(counts, max_stateWeight == 50) by policySetInitiative\r\n| extend totalResources = todouble(nonCompliantCount + compliantCount + conflictCount + exemptCount)\r\n| extend totalCompliantResources = todouble(compliantCount + exemptCount)\r\n| extend compliancePercentage = iff(totalResources == 0 or (totalCompliantResources == 0 and nonCompliantCount == 0), todouble(100), 100 * totalCompliantResources / totalResources)\r\n| project policySetInitiative, compliancePercentageEx = toint(round(compliancePercentage, 1))\r\n| order by compliancePercentageEx asc\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "chartType",
                                "value": 1
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Hover over bar to see policy initiative name and its compliance percentage",
                            "title": "Resource compliance percentage by policy initiative"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryChartTile"
                    },
                    "position": {
                        "colSpan": 10,
                        "rowSpan": 4,
                        "x": 6,
                        "y": 9
                    }
                },
                "8": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resources compliance percentage by policy group name"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates' and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend policyDefinitionId = tolower(properties.policyDefinitionId), policyGroups = properties.policyDefinitionGroupNames, policySetDefinitionName = tolower(properties.policySetDefinitionName)\r\n| mv-expand parsed_policy_groups = policyGroups\r\n| where parsed_policy_groups hasprefix \"so.\"\r\n| extend parsed_policy_groups = trim('so.',tostring(parsed_policy_groups))\r\n| project properties, policyDefinitionId, parsed_policy_groups\r\n| extend complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), stateWeight = tolong(properties.stateWeight)\r\n| summarize max(stateWeight) by resourceId, tostring(parsed_policy_groups)\r\n| summarize counts = count() by tostring(parsed_policy_groups), max_stateWeight\r\n| summarize nonCompliantCount = sumif(counts, max_stateWeight == 300), compliantCount = sumif(counts, max_stateWeight == 200), conflictCount = sumif(counts, max_stateWeight == 100), exemptCount = sumif(counts, max_stateWeight == 50) by tostring(parsed_policy_groups)\r\n| extend totalResources = todouble(nonCompliantCount + compliantCount + conflictCount + exemptCount)\r\n| extend totalCompliantResources = todouble(compliantCount + exemptCount)\r\n| extend compliancePercentage = iff(totalResources == 0 or (totalCompliantResources == 0 and nonCompliantCount == 0), todouble(100), 100 * totalCompliantResources / totalResources)\r\n| project toupper(parsed_policy_groups), compliancePercentageEx = toint(round(compliancePercentage, 1))\r\n| order by compliancePercentageEx asc\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "chartType",
                                "value": 1
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Hover over bar to see policy group name and its compliance percentage",
                            "title": "Resource compliance percentage by policy group name"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryChartTile"
                    },
                    "position": {
                        "colSpan": 16,
                        "rowSpan": 4,
                        "x": 0,
                        "y": 13
                    }
                },
                "9": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Non-Compliant and exempt resources"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates' and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| where properties.complianceState in (\"NonCompliant\", \"Exempt\")\r\n| extend complianceState = tostring(properties.complianceState),resourceId = tolower(properties.resourceId), resourceType = tostring(properties.resourceType), policySetDefinitionName = tostring(properties.policySetDefinitionName), subscriptionId = tostring(properties.subscriptionId), policyDefinitionName = tostring(properties.policyDefinitionName)\r\n| distinct resourceId, policySetDefinitionName, complianceState, resourceType, subscriptionId, policyDefinitionName\r\n| join kind=leftouter (\r\n   resources\r\n   | project resourceId=tolower(id), resourceName=name, resourceGroup\r\n  ) on resourceId\r\n| join kind=inner (\r\n    resourcecontainers\r\n    | where type == 'microsoft.resources/subscriptions'\r\n    | project subscriptionId, subscriptionName = name\r\n  ) on subscriptionId\r\n|join kind=inner (\r\n    PolicyResources\r\n    | where type == \"microsoft.authorization/policydefinitions\"\r\n    | extend policyName = tostring(properties.displayName)\r\n    | project policyName, policyDefinitionName = name\r\n  ) on policyDefinitionName\r\n| extend ['Resource name']= iff(resourceName==\"\", subscriptionName, resourceName)\r\n| project ['Compliance state']=complianceState, ['Policy initiative']=policySetDefinitionName,['Policy definition']=policyName, ['Resource type']=resourceType, ['Resource name'] , ['Resource group']=resourceGroup,  ['Subscription']=subscriptionName\r\n| order by ['Compliance state'] desc, ['Resource type'], ['Resource name'] asc\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "List of non-compliant and exempt resources for all policies",
                            "title": "Non-Compliant and exempt resources"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryGridTile"
                    },
                    "position": {
                        "colSpan": 16,
                        "rowSpan": 5,
                        "x": 0,
                        "y": 17
                    }
                },
                "10": {
                    "metadata": {
                        "inputs": [],
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "",
                                    "markdownSource": 1,
                                    "markdownUri": null,
                                    "subtitle": "",
                                    "title": "Data residency compliance"
                                }
                            }
                        },
                        "type": "Extension/HubsExtension/PartType/MarkdownPart"
                    },
                    "position": {
                        "colSpan": 16,
                        "rowSpan": 1,
                        "x": 0,
                        "y": 22
                    }
                },
                "11": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Non-compliant resources by location"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "policyResources\r\n| where type == 'microsoft.policyinsights/policystates'\r\n| extend resourceId = tolower(properties.resourceId), policyAssignmentScope = tolower(properties.policyAssignmentScope), complianceState = tostring(properties.complianceState)\r\n| where policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and policyAssignmentScope endswith '' and complianceState == 'NonCompliant'\r\n| mv-expand parsed_policy_groups = parse_json(tolower(properties.policyDefinitionGroupNames))\r\n| where tostring(parsed_policy_groups) == \"so.1 - data residency\"\r\n| join kind=inner  (\r\n   resources\r\n   | where isnotnull(location)\r\n   | project resourceId=tolower(id), resourceName=name, resourceGroup, resourcelocation = location\r\n  ) on resourceId\r\n| project resourcelocation, complianceState\r\n| summarize counts = count() by resourcelocation\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "chartType",
                                "value": 1
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "These resources are in non-compliant locations per the data residency policy",
                            "title": "Non-Compliant resources by location"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryChartTile"
                    },
                    "position": {
                        "colSpan": 5,
                        "rowSpan": 5,
                        "x": 0,
                        "y": 23
                    }
                },
                "12": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resources exempt from data residency policies"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates' and tostring(properties.complianceState)  == \"Exempt\" and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend policyAssignmentScope = tolower(properties.policyAssignmentScope), complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), resourceType = tostring(properties.resourceType), subscriptionId = tostring(properties.subscriptionId), policyDefinitionId = tostring(properties.policyDefinitionId), resourceLocation = tolower(properties.resourceLocation), policySetDefinitionName = tostring(properties.policySetDefinitionName), policyGroups = tolower(properties.policyDefinitionGroupNames)\r\n| mv-expand parsed_policy_groups = parse_json(policyGroups)\r\n| where tostring(parsed_policy_groups) == \"so.1 - data residency\"\r\n| join kind=leftouter (\r\n   resources\r\n   | project resourceId=tolower(id), resourceName=name, resourceGroup\r\n  ) on resourceId\r\n| join kind=inner (\r\n    resourcecontainers\r\n    | where type == 'microsoft.resources/subscriptions'\r\n    | project subscriptionId, subscriptionName = name\r\n  ) on subscriptionId\r\n| project ['Compliance state']=complianceState, ['Policy initiative']=policySetDefinitionName, ['Resource type']=resourceType, ['Resource name']=resourceName, ['Resource location']=resourceLocation\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "These resources are exempt from data residency policies",
                            "title": "Resources exempt from data residency policies"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryGridTile"
                    },
                    "position": {
                        "colSpan": 11,
                        "rowSpan": 5,
                        "x": 5,
                        "y": 23
                    }
                },
                "13": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resources outside of approved regions"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "policyResources\r\n| where type == 'microsoft.policyinsights/policystates'  and  properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend  complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), resourceType = tostring(properties.resourceType),   resourceLocation = tolower(properties.resourceLocation), policySetDefinitionName = tostring(properties.policySetDefinitionName), policyGroups = tolower(properties.policyDefinitionGroupNames)\r\n| where (complianceState == 'NonCompliant' or complianceState == 'Exempt')\r\n| mv-expand parsed_policy_groups = parse_json(policyGroups)\r\n| where tostring(parsed_policy_groups) == \"so.1 - data residency\"\r\n| join kind=leftouter (\r\n   resources\r\n   | project resourceId=tolower(id), resourceName=name, resourceGroup\r\n  ) on resourceId\r\n| project ['Compliance state']=complianceState, ['Policy initiative']=policySetDefinitionName, ['Resource type']=resourceType, ['Resource name']=resourceName, ['Resource location']=resourceLocation,  ['Resource group']=resourceGroup\r\n| order by ['Compliance state'] desc, ['Resource type'], ['Resource name'] asc\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "These are the resources deployed outside of an approved region",
                            "title": "Resources outside of approved regions"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryGridTile"
                    },
                    "position": {
                        "colSpan": 16,
                        "rowSpan": 5,
                        "x": 0,
                        "y": 28
                    }
                },
                "14": {
                    "metadata": {
                        "inputs": [],
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "",
                                    "markdownSource": 1,
                                    "markdownUri": null,
                                    "subtitle": "",
                                    "title": "Confidential computing"
                                }
                            }
                        },
                        "type": "Extension/HubsExtension/PartType/MarkdownPart"
                    },
                    "position": {
                        "colSpan": 16,
                        "rowSpan": 1,
                        "x": 0,
                        "y": 33
                    }
                },
                "15": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resource compliance score for customer-managed keys policies"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n|where type == 'microsoft.policyinsights/policystates' and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend  policyDefinitionId = tolower(properties.policyDefinitionId), policyGroups = tolower(properties.policyDefinitionGroupNames)\r\n| mv-expand parsed_policy_groups = parse_json(policyGroups)\r\n| where tostring(parsed_policy_groups) == \"dashboard-storage security\"\r\n| extend complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), resourceType = tolower(properties.resourceType), stateWeight = tolong(properties.stateWeight)\r\n| summarize max(stateWeight) by resourceId, resourceType\r\n| project resourceId, resourceType, complianceState = iff(max_stateWeight == 300, 'NonCompliant', iff(max_stateWeight == 200, 'Compliant', iff(max_stateWeight == 100 , 'Conflict', iff(max_stateWeight == 50, 'Exempt', 'UnknownResource'))))\r\n| summarize counts = count() by complianceState\r\n| summarize compliantCount = sumif(counts, complianceState == 'Compliant' or complianceState == 'Exempt'), nonCompliantCount = sumif(counts, complianceState == 'Conflict' or complianceState == 'NonCompliant')\r\n| extend totalNum = toint(compliantCount + nonCompliantCount)\r\n| extend compliancePercentageVal = iff(totalNum == 0, todouble(100), 100 * todouble(compliantCount) / totalNum)\r\n| project ['Confidentiality compliance percentage (includes compliant and exempt)'] = strcat(tostring(round(compliancePercentageVal, 1)), '% (', tostring(compliantCount),' out of ', tostring(totalNum), ')')\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Percent of resources compliant with customer-managed keys policies",
                            "title": "Resource compliance score for customer-managed keys policies"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQuerySingleValueTile"
                    },
                    "position": {
                        "colSpan": 8,
                        "rowSpan": 2,
                        "x": 0,
                        "y": 34
                    }
                },
                "16": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resource compliance score for confidential computing policies"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n|where type == 'microsoft.policyinsights/policystates'  and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend  policyDefinitionId = tolower(properties.policyDefinitionId), policyGroups = tolower(properties.policyDefinitionGroupNames), policySetDefinitionName = tolower(properties.policySetDefinitionName)\r\n| mv-expand parsed_policy_groups = parse_json(policyGroups)\r\n| where tostring(parsed_policy_groups) in (\"so.4 - azure confidential computing\")\r\n| extend complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), resourceType = tolower(properties.resourceType), stateWeight = tolong(properties.stateWeight)\r\n| summarize max(stateWeight) by resourceId, resourceType\r\n| project resourceId, resourceType, complianceState = iff(max_stateWeight == 300, 'NonCompliant', iff(max_stateWeight == 200, 'Compliant', iff(max_stateWeight == 100 , 'Conflict', iff(max_stateWeight == 50, 'Exempt', 'UnknownResource'))))\r\n| summarize counts = count() by complianceState\r\n| summarize compliantCount = sumif(counts, complianceState == 'Compliant' or complianceState == 'Exempt'), nonCompliantCount = sumif(counts, complianceState == 'Conflict' or complianceState == 'NonCompliant')\r\n| extend totalNum = toint(compliantCount + nonCompliantCount)\r\n| extend compliancePercentageVal = iff(totalNum == 0, todouble(100), 100 * todouble(compliantCount) / totalNum)\r\n| project ['Confidentiality compliance percentage (includes compliant and exempt)'] = strcat(tostring(round(compliancePercentageVal, 1)), '% (', tostring(compliantCount),' out of ', tostring(totalNum), ')')\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "Percent of resources compliant with confidential computing policies",
                            "title": "Resource compliance score for confidential computing policies"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQuerySingleValueTile"
                    },
                    "position": {
                        "colSpan": 8,
                        "rowSpan": 2,
                        "x": 8,
                        "y": 34
                    }
                },
                "17": {
                    "metadata": {
                        "inputs": [
                            {
                                "isOptional": true,
                                "name": "chartType"
                            },
                            {
                                "isOptional": true,
                                "name": "isShared"
                            },
                            {
                                "isOptional": true,
                                "name": "queryId"
                            },
                            {
                                "isOptional": true,
                                "name": "partTitle",
                                "value": "Resources exempt from confidential computing policies"
                            },
                            {
                                "isOptional": true,
                                "name": "query",
                                "value": "PolicyResources\r\n| where type == 'microsoft.policyinsights/policystates' and tostring(properties.complianceState)  == \"Exempt\" and properties.policyAssignmentScope startswith '/providers/Microsoft.Management/managementGroups/${root_prefix}' and properties.policyAssignmentScope endswith '${root_postfix}'\r\n| extend  policyDefinitionId = tolower(properties.policyDefinitionId),complianceState = tostring(properties.complianceState), resourceId = tolower(properties.resourceId), resourceType = tostring(properties.resourceType), policySetDefinitionName = tostring(properties.policySetDefinitionName),subscriptionId = tostring(properties.subscriptionId), policyGroups = tolower(properties.policyDefinitionGroupNames)\r\n| mv-expand parsed_policy_groups = parse_json(policyGroups)\r\n| where tostring(parsed_policy_groups) in (\"so.3 - customer-managed keys\", \"so.4 - azure confidential computing\")\r\n| join kind=leftouter (\r\n   resources\r\n   | project resourceId=tolower(id), resourceName=name, resourceGroup\r\n  ) on resourceId\r\n| join kind=inner (\r\n    resourcecontainers\r\n    | where type == 'microsoft.resources/subscriptions'\r\n    | project subscriptionId, subscriptionName = name\r\n  ) on subscriptionId\r\n| project ['Compliance State']=complianceState, ['Policy initiative']=policySetDefinitionName, ['Policy definition id']=policyDefinitionId, ['Resource type']=resourceType, ['Resource name']=resourceName, ['Subscription id']=subscriptionId, ['Policy group']=tostring(parsed_policy_groups)\r\n"
                            },
                            {
                                "isOptional": true,
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                }
                            }
                        ],
                        "partHeader": {
                            "subtitle": "These resources are exempt from confidential computing policies",
                            "title": "Resources exempt from confidential computing policies"
                        },
                        "settings": {},
                        "type": "Extension/HubsExtension/PartType/ArgQueryGridTile"
                    },
                    "position": {
                        "colSpan": 16,
                        "rowSpan": 5,
                        "x": 0,
                        "y": 36
                    }
                }
            }
        }
    },
    "metadata": {
        "model": {
            "timeRange": {
                "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange",
                "value": {
                    "relative": {
                        "duration": 24,
                        "timeUnit": 1
                    }
                }
            }
        }
    }
}
