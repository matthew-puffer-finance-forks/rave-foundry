

rm -rf src/*
cp -R ../rave/src/* src
forge create --rpc-url "http://127.0.0.1:8545" --private-key "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6" src/RAVE.sol:RAVE
pushd ../rave/test/scripts > /dev/null
rave_inputs=$(./raveEnclaveVerify.sh)
popd > /dev/null

calldata=$(cast calldata "rave(bytes,bytes,bytes,bytes,bytes,bytes32,bytes32)" $rave_inputs
cast send $RAVE_ADDRESS $CALLDATA