[
    {
        "environment": [
            {
                "name": "AUTH_TOKEN",
                "value": "kqPYCNNbwOQQZGl21YIK0iyc56pwPSomqnl8EdChl989pdow"
            },
            {
                "name": "APPLE_MUSIC_PRIVATE_KEY",
                "value": "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgehkNPJsJvFVlMgKEuK9pMaTScKiC266yEHxYAGrgk3ygCgYIKoZIzj0DAQehRANCAASkK7QGzhxO9ZuTuEhbzkfLSylvirNW8b/+UYcwCuvKtIiyV/mVy+dV6hiFKHXUFz4zx2WKASnFyRPSz1DPtDyv"
            },
            {
                "name": "APPLE_MUSIC_KEY_IDENTIFIER",
                "value": "8TPZSRP0GQ"
            },
            {
                "name": "APPLE_MUSIC_TEAM_ID",
                "value": "AZXN5VK5MU"
            }
        ],
        "essential": true,
        "image": "dgrew/tokengenerator:2b02e22497da6abe732b604a18507e618caea95d",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "tabwriter-logs",
                "awslogs-region": "eu-west-2",
                "awslogs-stream-prefix": "tabwriter-"
            }
        },
        "name": "tabwriter-task",
        "portMappings": [
            {
                "containerPort": 8399
            }
        ]
    }
]
