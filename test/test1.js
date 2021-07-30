const CBSC = artifacts.require('CBSC');

contract("Test 1", async (accounts) => {

    /*
    * Instance to connect to smart contract via Ganache-CLI
    * */
    let instance;

    /*
    * The flow variable
    * true = happy flow
    * false = discussion flow
    * */
    let flow;

    /*
    * Check if test has started
    * default = false
    * */
    let start;

    /*
    * Setup variables before tests start
    * */
    before('setup contract', async () => {

        /*
        * Deploy smart contract to instance to access the deployed contract
        * */
        instance = await CBSC.deployed();

        /*
        * Set start to false for first run
        * */
        start = false;

        /*
        * Monitor Sol Event (emits) after changing the blockchain state
        * error = event fired with error message (state change failed)
        * result = successful result containing transaction details
        * */
        instance.CommitmentStateLog({}, async (error, result) => {
            if (error) {
                flow = false;
                console.log(error);
            }
            if (result) {
                flow = true;
                console.log(result.args[0] + ' on ' + result.transactionHash);
            } else {
                flow = false;
                console.log('No error & no result');
            }
        });
    })

    it("Happy flow", async () => {
        if (flow == true || start == false) {
            console.log('Following the happy flow')
            start = true;
            await instance.Test('Juppie');
        } else {
            console.log('Happy flow test should fail')
        }

    })

    it("Discussion flow", async () => {
        if (flow == false) {
            console.log('Following the discussion flow')
            await instance.Test('Jappie');
        } else {
            console.log('Discussion flow should fail')
        }
    })
})
