# Quickstart Repo Crawler POC

This tool allows you to schedule repo crawler jobs quickly on any standard linux system

Additional info can be found [here](https://cyral.com/docs/v3.0/policy/repo-crawler/install/)

# Install

You'll need to clone this git repository (or download/extract) on to a basic linux system and run the `install.sh` script.

```
git clone https://github.com/cyral-quickstart/quickstart-crawler-poc.git
cd quickstart-crawler-poc
sudo ./install.sh
```

# Configuration
Configuration can be done in a few simple steps

1) Login to your Control Plane
    1) Get an API Key
        1) From the bottom left select `API Access Keys`
        1) Select the `+` to add a new key
        1) Give it a name and select the following permissions
            * View Datamaps
            * Modify Policies
            * Repo Crawler
        1) Save the produced ID/Secret
    1) Setup a Data Repo
        1) If you havent already, [add a Data Repo](https://cyral.com/docs/manage-repositories/repo-track)
1) SSH to the Instance you installed the Crawler on
    1) Run `crawler`
    1) Configure the control plane information
    1) Configure the repo job

Once the Job has successfuly run you can see if the job successfully reporting by going to `Data Repos > Your Repo > Data Map > Auto Updates`

# Logs
Logs will only be stored for the last job run and will be located at `~/.local/cyral` and will be in the format of `crawler-<jobname>.log`