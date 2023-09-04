
# Utils.
deploy_addr="python3 -c \"import re, sys; x = sys.stdin.read(); "
deploy_addr+="print(re.findall('Deployed to: 0x([^\s]+)', x)[0],)\""

chmod -R 777 lib/rave
rm -rf lib/rave
cp -R ../rave lib/rave
chmod -R 777 lib/rave

# Deploy nodeptr library.
deploy_out=$(forge create --rpc-url "http://127.0.0.1:8545" --private-key "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6" lib/rave/src/ASN1Decode.sol:NodePtr)
nodeptr_addr=$(eval "echo '$deploy_out' | $deploy_addr")

# Deploy Asn1Decode library.
deploy_out=$(forge create --rpc-url "http://127.0.0.1:8545" --private-key "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6" lib/rave/src/ASN1Decode.sol:Asn1Decode)
asn1_addr=$(eval "echo '$deploy_out' | $deploy_addr")

# Deploy main rave contract
deploy_out=$(forge create --rpc-url "http://127.0.0.1:8545" --private-key "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6" src/Main.sol:Main --libraries lib/rave/src/ASN1Decode.sol:NodePtr:0x$nodeptr_addr --libraries lib/rave/src/ASN1Decode.sol:Asn1Decode:0x$asn1_addr)
rave_addr=$(eval "echo '$deploy_out' | $deploy_addr")

pushd "../rave/test/scripts/bin" > /dev/null

func_sig="rave(bytes,bytes,bytes,bytes,bytes,bytes,bytes)"
rave_inputs=$(./ss_to_abi '/home/matthew/projects/secure-signer')
prepared=$(./echo "$rave_inputs" | ./prepend_func_sig "$func_sig")
popd > /dev/null

echo $prepared

out=$(cast call "0x$rave_addr" 0x$prepared --private-key "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6")
echo $out

exit

