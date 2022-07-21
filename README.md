# Rezilion Orb

With Rezilion orb, applications can be built securely by validating vulnerabilities early in the development process. developers can focus on exploitable vulnerabilities and reduce their backlog and patching by 85%.
With Rezilion, you’ll gain a deep understanding of your environment, uncover and validate vulnerabilities in your applications and container images, and export the output in auditing formats.
To use this orb, you need a Rezilion license.

# Installation Guide
1. Add "REZILION_LICENSE_KEY" environment variable to the CircleCI project
2. Add corresponding "rezilion/rezilion_start" and "rezilion/rezilion_stop" steps to the tests you wish to validate
3. Define the IMAGE_TO_SCAN variable for "rezilion/rezilion_start" if needed, Depending on your usecase, This parameter is optional. 

    ** If only one image is used in a pipeline, leave it blank. Enter the requested image name if using multiple images in a pipeline. See our user guide for more information.


5. Add the validate job to the end of your workflow. 

    ** Make sure the job runs after all the test jobs.
    
    
# Documentation
Full orb documentation and examples can be found at https://circleci.com/developer/orbs/orb/rezilion/rezilion

User guide can be found at https://rezilion.force.com/support/s/article/Rezilion-in-CircleCI-User-Guide
