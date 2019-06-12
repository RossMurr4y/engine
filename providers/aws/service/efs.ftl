[#ftl]

[#-- Resources --]
[#assign AWS_EFS_RESOURCE_TYPE = "efs" ]
[#assign AWS_EFS_MOUNTTARGET_RESOURCE_TYPE = "efsMountTarget" ]

[#function formatEFSId tier component extensions...]
    [#return formatComponentResourceId(
        AWS_EFS_RESOURCE_TYPE
        tier,
        component,
        extensions)]
[/#function]

[#function formatDependentEFSMountTargetId resourceId extensions...]
    [#return formatDependentResourceId(
                AWS_EFS_MOUNTTARGET_RESOURCE_TYPE
                resourceId,
                extensions)]
[/#function]

[#assign EFS_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "UseRef" : true
        },
        ARN_ATTRIBUTE_TYPE : {
            "UseRef" : true
        }
    }
]

[#assign EFS_MOUNTTARGET_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "UseRef" : true
        },
        ARN_ATTRIBUTE_TYPE : {
            "UseRef" : true
        }
    }
]

[#assign outputMappings +=
    {
        AWS_EFS_RESOURCE_TYPE : EFS_OUTPUT_MAPPINGS,
        AWS_EFS_MOUNTTARGET_RESOURCE_TYPE : EFS_MOUNTTARGET_MAPPINGS
    }
]

[#macro createEFS mode id name tier component encrypted]
    [@cfResource
        mode=mode
        id=id
        type="AWS::EFS::FileSystem"
        properties=
            {
                "PerformanceMode" : "generalPurpose",
                "FileSystemTags" : getCfTemplateCoreTags(name, tier, component)
            } +
            encrypted?then(
                {
                    "Encrypted" : true,
                    "KmsKeyId" : getReference(formatSegmentCMKId(), ARN_ATTRIBUTE_TYPE)
                },
                {}
            )
        outputs=EFS_OUTPUT_MAPPINGS
    /]
[/#macro]

[#macro createEFSMountTarget mode id efsId subnet securityGroups dependencies="" ]
    [@cfResource
        mode=mode
        id=id
        type="AWS::EFS::MountTarget"
        properties=
            {
                "SubnetId" : subnet?is_enumerable?then(
                                subnet[0],
                                subnet
                ),
                "FileSystemId" : getReference(efsId),
                "SecurityGroups": getReferences(securityGroups)
            }
        outputs=EFS_MOUNTTARGET_MAPPINGS
        dependencies=dependencies
    /]
[/#macro]