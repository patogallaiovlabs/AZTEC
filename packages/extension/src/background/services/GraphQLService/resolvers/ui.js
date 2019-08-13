import assetModel from '~database/models/asset';
import AuthService from '~background/services/AuthService';
import {
    ensureKeyvault,
    ensureAccount,
} from '../decorators';
import mergeResolvers from './utils/mergeResolvers';
import base from './base';

const uiResolvers = {
    Mutation: {
        registerExtension: async (_, args) => ({
            account: await AuthService.registerExtension(args),
        }),
        registerAddress: ensureKeyvault(async (_, args) => ({
            account: await AuthService.registerAddress({
                address: args.address,
                linkedPublicKey: args.linkedPublicKey,
                registeredAt: args.registeredAt,
            }),
        })),
        login: ensureAccount(async (_, args) => ({
            session: await AuthService.login(args),
        })),
        approveAssetForDomain: ensureAccount(async (_, args) => {
            await AuthService.enableAssetForDomain(args);
            return {
                asset: await assetModel.get({
                    address: args.asset,
                }),
            };
        }),
    },
};

export default mergeResolvers(
    base,
    uiResolvers,
);
