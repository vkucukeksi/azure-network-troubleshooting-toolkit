# Azure Network Troubleshooting Toolkit

A collection of scripts and troubleshooting playbooks used to diagnose common **Azure networking issues**.

This repository contains **real-world troubleshooting patterns** for problems such as routing failures, VNet connectivity issues, firewall routing problems, DNS resolution issues, and private endpoint connectivity.

The goal of this project is to document **practical debugging techniques and automation scripts** that help quickly identify and resolve Azure network issues.

---

## Key Troubleshooting Areas

* VNet peering connectivity
* User Defined Routes (UDR)
* Effective route analysis
* Firewall and hub-spoke routing
* DNS resolution issues
* Private endpoint connectivity
* Azure Network Watcher diagnostics

---

## Repository Structure

```
azure-network-troubleshooting-toolkit
│
├── case-studies
│   └── udr-firewall-bypass.md
│
├── scripts
│   ├── connectivity
│   │   └── Test-VNetConnectivity.ps1
│   ├── routing
│   │   └── Get-AzureEffectiveRoutes.ps1
│   ├── dns
│   │   └── (empty)
│   └── peering
│       └── (empty)
│
├── diagrams
│   └── hub-spoke-routing.png
│
└── README.md
```

---

## Case Study Example

### Firewall Routing Issue (Temporary UDR Bypass)

#### Problem

Traffic between Azure VNets failed due to routing through a firewall appliance in the hub network.

The firewall policy blocked required traffic between spokes.

#### Investigation Steps

1. Verified VNet peering configuration
2. Checked effective routes on the VM
3. Reviewed NSG rules
4. Confirmed traffic path through hub firewall

#### Temporary Mitigation

User Defined Routes (UDRs) were applied to temporarily bypass the firewall and restore connectivity.

Example route change:

```
Destination: Spoke subnet
Next hop: Virtual Network
```

This allowed traffic to flow directly through VNet peering while firewall rules were being updated.

---

## Example Troubleshooting Commands

Check effective routes:

```
Get-AzNetworkInterface -Name <nic-name> -ResourceGroupName <rg> |
Get-AzEffectiveRouteTable
```

Check VNet peering:

```
Get-AzVirtualNetworkPeering -ResourceGroupName <rg> -VirtualNetworkName <vnet>
```

Test connectivity:

```
Test-NetConnection -ComputerName <ip-address> -Port 443
```

---

## Learning Goals

This repository focuses on:

* Improving Azure networking troubleshooting workflows
* Automating diagnostics with PowerShell
* Documenting real-world troubleshooting scenarios
* Building reusable troubleshooting scripts

---

## Disclaimer

All examples in this repository use **generic architectures and anonymized network details**.


---

## Future Improvements

* Additional case studies
* Automated network diagnostic scripts
* Azure Network Watcher integrations
* GitHub Actions automated connectivity tests

---
