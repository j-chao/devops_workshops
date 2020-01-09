#!/bin/bash
# This script downloads the necessary Optum CA certificates to be able to access the intranet, as well as websites via TLS

curl https://repo1.uhc.com/artifactory/UHG-certificates/optum/Optum_Internal_Issuing_CA1.cer -o optum_certs/Optum_Internal_Issuing_CA1.crt
curl https://repo1.uhc.com/artifactory/UHG-certificates/optum/Optum_Internal_Issuing_CA2.cer -o optum_certs/Optum_Internal_Issuing_CA2.crt
curl https://repo1.uhc.com/artifactory/UHG-certificates/optum/Optum_Internal_Policy_CA.cer -o optum_certs/Optum_Internal_Policy_CA.crt
curl https://repo1.uhc.com/artifactory/UHG-certificates/optum/Optum_Internal_Policy_CA2.cer -o optum_certs/Optum_Internal_Policy_CA2.crt
curl https://repo1.uhc.com/artifactory/UHG-certificates/optum/OptumInternalIssuingCA3.cer -o optum_certs/OptumInternalIssuingCA3.crt
curl https://repo1.uhc.com/artifactory/UHG-certificates/optum/Optum_Root_CA.cer -o optum_certs/Optum_Root_CA.crt

