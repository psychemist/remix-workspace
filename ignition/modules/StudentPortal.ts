import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const StudentPortal = buildModule("StudentPortalModule", (m) => {

    const studentPortal = m.contract("StudentPortal");

    return { studentPortal };
});

export default StudentPortal;


// Deployed StudentPortal: 
