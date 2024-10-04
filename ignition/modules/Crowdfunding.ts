import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const Crowdfunding = buildModule("CrowdfundingModule", (m) => {

    const crowdfunding = m.contract("Crowdfunding");

    return { crowdfunding };
});

export default Crowdfunding;


// Deployed Crowdfunding: 
