# Hyperledger Fabric: package, install and approve chaincodes

Inspired by [Hyperledger Fabric](https://hyperledger-fabric.readthedocs.io/en/latest/install.html) and [Fabric Samples](https://github.com/hyperledger/fabric-samples).

Using this [deploy.sh](https://github.com/nimaghazanfari/package-install-approve-chaincode/deploy.sh) file, you can automatically package, install and approve all of your chaincodes into default Hyperledger Fabric Orgs (Org1 and Org2).

## Getting started with the Fabric samples

To use the Fabric samples, you need to download the Fabric Docker images and the Fabric CLI tools. First, make sure that you have installed all of the [Fabric prerequisites](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html) (including [JQ](https://stedolan.github.io/jq/download/)). You can then follow the instructions to [Install the Fabric Samples, Binaries, and Docker Images](https://hyperledger-fabric.readthedocs.io/en/latest/install.html) in the Fabric documentation. In addition to downloading the Fabric images and tool binaries, the Fabric samples will also be cloned to your local machine.

## Test network

The [Fabric test network](test-network) in the samples repository provides a Docker Compose based test network with two
Organization peers and an ordering service node. You can use it on your local machine to run the samples listed below.
You can also use it to deploy and test your own Fabric chaincodes and applications. To get started, see
the [test network tutorial](https://hyperledger-fabric.readthedocs.io/en/latest/test_network.html).

## How to use this code?

Create a copy of [deploy.sh](https://github.com/nimaghazanfari/package-install-approve-chaincode/deploy.sh) under the `test-network` directory of fabric-samples and modify these lines of code according to your project setup and contracts names. (if you are using a different folder structure, you might need to change orther parts as well)
```
export CHAINCODES=("fabcar" "fabcar2")
export PROJNAME=fabcar
```
Here in this example, my project is located inside a folder called `PROJNAME=fabcar` and contains only two chaincodes called `("fabcar" "fabcar2")`. You can add as many chaincodes as your project contains.

Save your `deploy.sh` and run this command:
### `./deploy.sh run`


## License
MIT
