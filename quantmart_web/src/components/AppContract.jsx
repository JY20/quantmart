import { Contract, Provider, cairo, CallData, shortString } from 'starknet';

const hash_provider = new Provider({ network: 'sepolia' });

const classHash = '';
const contractAddress = '';
const usdcTokenAddress = '0x53b40a647cedfca6ca84f542a0fe36736031905a9639a7f19a3c1e66bfd5080';
const strkTokenAddress = '0x4718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d';

export class AppContract {
    /* global BigInt */

    constructor() {
    }

    async getABI() {
        const contractClass = await hash_provider.getClassByHash(classHash);
        return contractClass.abi;
    }
}
