[#ftl]

[@addComponentDeployment
    type=CONFIGSTORE_COMPONENT_TYPE
    defaultGroup="solution"
/]

[@addComponent
    type=CONFIGSTORE_COMPONENT_TYPE
    properties=
        [
            {
                "Type"  : "Description",
                "Value" : "A configuration store to provide dynamic attributes"
            }
        ]
    attributes=
        [
            {
                "Names" : [ "Extensions", "Fragment", "Container" ],
                "Description" : "Extensions to invoke as part of component processing",
                "Types" : ARRAY_OF_STRING_TYPE,
                "Default" : []
            },
            {
                "Names" : "Table",
                "Children" : dynamoDbTableChildConfiguration
            },
            {
                "Names" : "SecondaryKey",
                "Description" : "Uses the name of the branch to provide a secondary sort key on branches - id being the primary",
                "Types" : BOOLEAN_TYPE,
                "Default" : false
            }
        ]
/]

[@addChildComponent
    type=CONFIGSTORE_BRANCH_COMPONENT_TYPE
    properties=
        [
            {
                "Type" : "Description",
                "Value" : "A branch of configuration which belongs to a config store"
            },
            {
                "Type" : "Providers",
                "Value" : [ "aws" ]
            },
            {
                "Type" : "ComponentLevel",
                "Value" : "solution"
            }
        ]
    attributes=
        [
            {
                "Names" : "Links",
                "Subobjects" : true,
                "Children" : linkChildrenConfiguration
            },
            {
                "Names" : "States",
                "Description" : "A writable attribute in the config branch",
                "Subobjects" : true,
                "Children" : [
                    {
                        "Names" : "InitialValue",
                        "Description" : "The initial value that will be applied to the state",
                        "Types" : STRING_TYPE,
                        "Default" : "-"
                    }
                ]
            }
        ]
    parent=CONFIGSTORE_COMPONENT_TYPE
    childAttribute="Branches"
    linkAttributes="Branch"
/]
