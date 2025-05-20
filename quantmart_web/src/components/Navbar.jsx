import React, { useState, useContext } from 'react';
import { 
    AppBar, 
    Toolbar, 
    Typography, 
    CssBaseline, 
    ThemeProvider, 
    createTheme, 
    Button, 
    Box,
    styled
} from '@mui/material';
import logo from '../assets/quantmart.png';
import { connect, disconnect } from "get-starknet";
import { encode } from "starknet";
import { AppContext } from './AppProvider';

const StyledToolbar = styled(Toolbar)({
    display: 'flex',
    justifyContent: 'center',
});

const NavbarContainer = styled(Box)(({ theme }) => ({
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: '80%',
    backgroundColor: 'white',
    borderRadius: '30px',
    padding: '8px 20px',
    boxShadow: '0px 4px 10px rgba(0, 0, 0, 0.1)',
    [theme.breakpoints.down("sm")]: {
        width: '90%',
        padding: '6px 15px'
    }
}));

const theme = createTheme({
    palette: {
        primary: {
            main: '#D1C4E9', 
        },
        background: {
            default: '#D1C4E9',
        },
    },
    typography: {
        fontFamily: 'Roboto, Arial, sans-serif',
        h6: {
            fontWeight: 600,
        },
    },
});

const Navbar = () => {
    const info = useContext(AppContext);
    const [connected, setConnected] = useState('Connect');
    const [walletName, setWalletName] = useState("");
    const [wallet, setWallet] = useState("");

    const handleDisconnect = async () => {
        await disconnect({ clearLastWallet: true });
        setWallet("");
        info.setWalletAddress(null);
        setWalletName("");
        setConnected('Connect');
    };

    const handleConnect = async () => {
        try {
            const getWallet = await connect();
            await getWallet?.enable({ starknetVersion: "v5" });
            setWallet(getWallet);
            const addr = encode.addHexPrefix(encode.removeHexPrefix(getWallet?.selectedAddress ?? "0x").padStart(64, "0"));
            info.setWalletAddress(addr);
            const profile = addr.substring(0, 2) + "..." + addr.substring(addr.length - 4);
            setConnected(profile);
            setWalletName(getWallet?.name || "");
            info.setWallet(getWallet);
        } catch (e) {
            console.log(e);
        }
    };

    const handleConnectButton = async () => {
        if (info.walletAddress == null) {
            handleConnect();
        } else {
            handleDisconnect();
        }
    };

    return (
        <ThemeProvider theme={theme}>
            <CssBaseline />
            <AppBar component="nav" position="sticky" sx={{ backgroundColor: '#D1C4E9', color: '#060f5e' }} elevation={0}>
                <StyledToolbar>
                    <NavbarContainer>
                        <Box
                            sx={{
                                display: 'flex',
                                alignItems: 'center',
                                gap: '16px',
                            }}
                        >
                            <Typography 
                                variant="h6" 
                                sx={{
                                    textDecoration: 'none',
                                    color: '#7E57C2',
                                    fontWeight: 'bold',
                                    display: 'flex',
                                    alignItems: 'center',
                                    transition: 'transform 0.3s ease',
                                    '&:hover': { color: '#6A4BA1' },
                                }}>
                                <img src={logo} alt="logo" style={{ width: "30px", height: "30px", borderRadius: '50%', marginRight: '10px' }} />
                                QuantMart
                            </Typography>
                        </Box>

                        <Box
                            sx={{
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'space-between',
                                gap: '16px',
                            }}
                        >
                            <Box sx={{ display: { xs: 'none', sm: 'block' } }}>
                                <Button
                                    variant="contained"
                                    sx={{
                                        backgroundColor: '#7E57C2',
                                        color: 'white',
                                        fontWeight: 'bold',
                                        borderRadius: '30px',
                                        padding: '10px 20px',
                                        '&:hover': { backgroundColor: '#6A4BA1' },
                                    }}
                                    onClick={handleConnectButton}
                                >
                                    {connected}
                                </Button>
                            </Box>
                        </Box>
                    </NavbarContainer>
                </StyledToolbar>
            </AppBar>
        </ThemeProvider>
    );
};

export default Navbar;
