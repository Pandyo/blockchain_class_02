import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const deployTipJarPlus: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  await deploy("TipJarPlus", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  const tipJarPlus = await hre.ethers.getContract<Contract>("TipJarPlus", deployer);

  console.log("TipJarPlus balance:", (await tipJarPlus.getBalance()).toString());
};

export default deployTipJarPlus;

deployTipJarPlus.tags = ["TipJarPlus"];
