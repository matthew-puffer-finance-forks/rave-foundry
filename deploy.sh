
# Utils.
deploy_addr="python3 -c \"import re, sys; x = sys.stdin.read(); "
deploy_addr+="print(re.findall('Deployed to: 0x([^\s]+)', x)[0],)\""

chmod -R 777 lib/rave
rm -rf lib/rave
cp -R ../rave lib/rave
chmod -R 777 lib/rave
deploy_out=$(forge create --rpc-url "http://127.0.0.1:8545" --private-key "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6" src/Main.sol:Main)
rave_addr=$(eval "echo '$deploy_out' | $deploy_addr")

pushd "../rave/test/scripts" > /dev/null
rave_inputs=$(./runEnclaveVerify.sh)


popd > /dev/null

out=$(cast call "0x$rave_addr" 0x$rave_inputs --private-key "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6")
echo $out

exit





#Deployer: 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720
#Deployed to: 0xA15BB66138824a1c7167f5E85b957d04Dd34E468
#Transaction hash: #0x3278a10b82f6c3d9a4460ac4bebfb1fc165a8e05853f73d996169674d8e9b1a2