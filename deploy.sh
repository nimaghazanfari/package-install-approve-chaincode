#!/bin/bash

# add your chaincode names into this array, and run the code to install all of them
export CHAINCODES=("fabcar" "fabcar2")
# set the folder name (project name) before run
export PROJNAME=fabcar

export CC_VERSION=1.0
export CC_SEQ=1
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export CC_NAME=""
export CORE_PEER_LOCALMSPID=""
export FABRIC_CFG_PATH=""
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=""
export CORE_PEER_MSPCONFIGPATH=""
export CORE_PEER_ADDRESS=""

function run() {
    peer version
    setOrg1
    packageForOrgs
    installOnOrg
    setOrg2
    installOnOrg
    setPackageID

    echo "Packag ID: ${CC_PACKAGE_ID}"
    
    for chaincode in "${arr[@]}"
    do
        CC_NAME=${chaincode}
        echo "Installing ${CC_NAME}"

        setOrg1
        approveForMyOrg
        
        setOrg2
        approveForMyOrg
        
        commitAndCheck
        
    done

}

function setOrg1() {
    CORE_PEER_LOCALMSPID="Org1MSP"
    FABRIC_CFG_PATH=${PWD}/../config/
    CORE_PEER_TLS_ENABLED=true
    CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
    CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    CORE_PEER_ADDRESS=localhost:7051
}

function setOrg2() {
    CORE_PEER_LOCALMSPID="Org2MSP"
    FABRIC_CFG_PATH=${PWD}/../config/
    CORE_PEER_TLS_ENABLED=true
    CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
    CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    CORE_PEER_ADDRESS=localhost:9051
}

function setPackageID() {
    CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled --output json | jq -r '.installed_chaincodes[0].package_id')
}

function packageForOrgs() {
    peer lifecycle chaincode package ${PROJNAME}.tar.gz --path ../chaincode/${PROJNAME}/javascript/ --lang node --label ${PROJNAME}_1
}

function installOnOrg() {
    peer lifecycle chaincode install ${PROJNAME}.tar.gz
}

function approveForMyOrg() {
    peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name $CC_NAME --version $CC_VERSION --package-id $CC_PACKAGE_ID --sequence $CC_SEQ --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
}

function commitAndCheck() {
    peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name $CC_NAME --version $CC_VERSION --sequence $CC_SEQ --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name $CC_NAME --version $CC_VERSION --sequence $CC_SEQ --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
    peer lifecycle chaincode querycommitted --channelID mychannel --name $CC_NAME --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
}


## Parse mode
if [[ $# -lt 1 ]] ; then
  echo "Add run to execute your command"
  exit 0
else
  MODE=$1
  shift
fi

if [ "${MODE}" == "run" ]; then
  run
else
  exit 1
fi
