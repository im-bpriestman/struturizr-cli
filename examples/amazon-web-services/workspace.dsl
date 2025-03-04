workspace "Amazon Web Services Example" "An example AWS deployment architecture." {

    model {
        springPetClinic = softwaresystem "Spring PetClinic" "Allows employees to view and manage information regarding the veterinarians, the clients, and their pets." "Spring Boot Application" {
            webApplication = container "Web Application" "Allows employees to view and manage information regarding the veterinarians, the clients, and their pets." "Java and Spring Boot"
            database = container "Database" "Stores information regarding the veterinarians, the clients, and their pets." "Relational database schema" "Database"
        }

        webApplication -> database "Reads from and writes to" "MySQL Protocol/SSL"

        live = deploymentEnvironment "Live" {

            deploymentNode "Amazon Web Services" {
                tags "Amazon Web Services - Cloud"

                region = deploymentNode "US-East-1" {
                    tags "Amazon Web Services - Region"

                    route53 = infrastructureNode "Route 53" {
                        tags "Amazon Web Services - Route 53"
                    }

                    elb = infrastructureNode "Elastic Load Balancer" {
                        tags "Amazon Web Services - Elastic Load Balancing"
                    }

                    deploymentNode "Autoscaling group" {
                        tags "Amazon Web Services - Auto Scaling"

                        deploymentNode "Amazon EC2" {
                            tags "Amazon Web Services - EC2"

                            webApplicationInstance = containerInstance webApplication
                        }
                    }

                    deploymentNode "Amazon RDS" {
                        tags "Amazon Web Services - RDS"

                        deploymentNode "MySQL" {
                            tags "Amazon Web Services - RDS MySQL instance"

                            databaseInstance = containerInstance database
                        }
                    }

                }
            }

            route53 -> elb "Forwards requests to" "HTTPS"
            elb -> webApplicationInstance "Forwards requests to" "HTTPS"
        }
    }

    views {
        deployment springPetClinic "Live" "AmazonWebServicesDeployment" {
            include *
            autolayout lr

            animation {
                route53
                elb
                webApplicationInstance
                databaseInstance
            }
        }

        styles {
            element "Element" {
                shape roundedbox
                background #ffffff
            }
            element "Database" {
                shape cylinder
            }
            element "Infrastructure Node" {
                shape roundedbox
            }
        }

        themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }

}