
function postToFlutterClient(data){
    monnifyFlutterClient.postMessage(JSON.stringify(data));
}

function showpaymentModal(monnifyPayload){
    initializeSDK(monnifyPayload)
}

function initializeSDK(payload) {
    try{    
        MonnifySDK.initialize({
            amount: payload.amount, 
            currency: payload.currency,
            reference: payload.reference,
            customerFullName: payload.customerFullName,
            customerEmail: payload.customerEmail,
            apiKey: payload.apiKey,
            contractCode: payload.contractCode,
            paymentDescription: payload.paymentDescription,
            metadata: payload.metadata || null,
            incomeSplitConfig: payload.incomeSplitConfig || [],
            paymentMethods: payload.paymentMethods || [],
            onLoadStart: () => {
                //SDK is initialized
                postToFlutterClient({"returnToCaller": false, "message": "Initializing SDK..."})
            },
            onLoadComplete: () => {
                //SDK is loaded
                postToFlutterClient({"returnToCaller": false, "message": "SDK initialized!!!"})
            },
            onComplete: function(response) {
                //Transaction is completed.
                postToFlutterClient({"returnToCaller": true, "message": "Success", "data": response})
            },
            onClose: function(data) {
                //Modal is closed here
                postToFlutterClient({"returnToCaller": true, "message": "", "data": data})
            }
        });
    }
    catch(e){
        data = {
            "status": "SDK_INITIALIZATION_FAILED",
            "responseCode":"SDK_INITIALIZATION_FAILED",
            "paymentStatus":"SDK_INITIALIZATION_FAILED",
            "responseMessage":`Error initializing SDK. Verify you are sending the right initialization payload: ${e}`,
        }
        postToFlutterClient(data);
    }
}

