---
title: "New Trend in Ransomware: The Target is No Longer Just the Network"
date: 2026-05-28
draft: false
tags: ["ransomware", "shinyhunters", "anubis", "nitrogen", "qilin", "healthcare", "education", "supply-chain", "exfiltration", "business-continuity"]
categories: ["Cybersecurity"]
summary: "Six months of ransomware cases — Canvas/Instructure, UMMC, Brockton Hospital, BridgePay, Foxconn — share one thing: attackers picked targets where downtime pressures third parties. A look at the leverage pattern, exposed weaknesses, and what to harden."
---

*Scott E Landry, MS, CRC, LRC, C|EH — Lieutenant Colonel, United States Army (ret) — Pendestdine Cybersecurity Counterintelligence Operator*

There has been quite a trend in ransomware and extortion cases over the last six months. In almost all cases, attackers have targeted organizations where any form of disruption would put pressure on others. There is no single malware family behind this trend nor is it centered on one particular industry. The trend here is leverage.

## The Leverage: Highly Impactful Sectors

Recent cases fit in four distinct categories.

### Education SaaS

The attack on Canvas/Instructure is a textbook example of platform concentration risk. The attack is attributed to [ShinyHunters]({{< ref "shinyhunters-supply-chain-wave-2026" >}}), and attackers claim they stole about 3.6 to 3.65 TB of data from millions of students and staff working with thousands of institutions. Instructure says they reached an "agreement" with the unauthorized party, but it is unclear whether it involved ransom payments. In either case, the experts say that the wording of the statement suggests a ransom settlement.

### Healthcare Delivery

The ransomware attack on University of Mississippi Medical Center forced the closure of 30 clinics and disrupted access to electronic health record databases, triggering downtime procedures. Signature Healthcare's Brockton Hospital was attacked in a way that disrupted access to electronic medical systems and required downtime procedures. Ambulances were diverted from the site, and non-urgent procedures were postponed. Anubis ransomware group claims it stole 2 TB of patient data. The exact size of the data loss remains unclear due to lack of confirmation from the affected parties.

### Payment Infrastructure

BridgePay Network Solutions confirmed a ransomware attack that caused disruptions in the payment gateway services used by merchants, municipalities, utilities, and public sector organizations. The initial reports did not specify any successful attempts to compromise the payment cards. This is important since payment processors serve as silent critical infrastructures for local governments and commercial organizations.

### Manufacturing and Supply Chain

Foxconn reported a cyberattack on its North American operations. The Nitrogen ransomware gang claimed they stole about 8 TB of data and over 11 million files from the organization. The exposed information includes data related to major technology customers and engineering-related information. While the exact extent of the data loss is currently uncertain, there are serious implications.

## Similar Outcomes

As you might have noticed, the outcomes in each case are similar.

In healthcare, the outcome is evident in delayed care and the diversion of ambulances, canceled or postponed procedures, and paper-based workflows. In payment processing, the outcome is in disruptions of transactions. In education, the outcome is in disruption of platforms, login-page defacement, and exposure of student/staff data. In manufacturing, the outcome is in operational disruptions and exposure of sensitive partner files.

The situation with ransom payment is ambiguous. The only confirmed case of ransom payment is Instructure that appears to have settled with the attackers despite not explicitly confirming that. In all other cases, it is unclear whether any ransom payments took place. This difference is crucial since any serious analysis should not turn a hacker's claim or ambiguous statements by the victims into a ransom payment fact.

## Attack Attribution

These ransomware cases do not involve known state-sponsored Advanced Persistent Threats (APTs). Instead, the attacks appear to be launched by financially-motivated criminal gangs.

ShinyHunters is reportedly behind the attack on Canvas. Nitrogen claims the attack on Foxconn. Anubis claims the attack on Signature Healthcare. Qilin claims the attack on Covenant Health which reportedly compromised 478,188 individuals.

It is unlikely that the attacks are sponsored by nation-states. Instead, it looks like financially-motivated groups are using APT-like targeting discipline against highly impactful sectors.

## Exposed Weaknesses

The following weaknesses can be seen in most cases.

First, Identity and Access Control remains the main point of entry. The majority of ransomware attacks start with stolen credentials, weak MFA, remote access vulnerabilities, misconfigured service accounts, and over-privileged users vs. Least-privilege best practices. In the Canvas case, the problem reportedly started with support ticket workflow issues in the Free-for-Teacher environment. Such low-trust workflows may become a starting point for larger-scale incidents when combined with access to production data.

Second, Segmentation is far from being adequate. Hospitals and payment processors must expect some degree of failure. Any attack that affects one environment will also affect payment APIs, clinical record systems, portals, and operational communication channels. This means the architecture is still too flat.

Third, SaaS is not properly considered as a critical infrastructure. The Canvas case clearly shows that tenant boundaries, support workflows, admin panels, API exports, and identity integration require the same protection as on-premises domain controllers.

Fourth, Data exfiltration detection remains insufficient. Modern ransomware groups routinely perform data theft prior to encryption. If they can exfiltrate terabytes of data without being detected, endpoint protection is not sufficient anymore. One must ask, are baselines irrelevant these days? Or have agentic-AI models been outfoxed by counter agentic-AI models? Organizations must monitor outbound traffic, cloud exports, impossible travel, API abuse, and logging — enough signal to reconstruct what happened after the fact and turn lessons learned into reference material for the next incident. Battle drills should run regularly, designed so the rehearsal itself carries the smallest possible blast radius. Each work shift should have a designated threat-watch role, with hand-off briefings to colleagues across shifts.

Fifth, Backups are unreliable. As stated in CISA's ransomware guidance, offline backups and regular tests for restoration must be implemented because many ransomware variants try to destroy the recovery path. Otherwise, backup may turn out to be just a hope.

## Strengthening Recommendations

The following measures must be taken to avoid such attacks.

Phishing-resistant MFA must be implemented for administrators, as well as for access to corporate VPNs, SaaS admin panels, cloud consoles, payment systems, EHR access, and remote management systems. All shared accounts should be removed. Secrets for service accounts should be rotated regularly. Least Privilege access policy should be enforced.

Second, organizations must create separate blast zones for domain controllers, backups, EHR systems, payment gateways, file shares, cloud management planes, and SaaS administration. This can be done with network segmentation, privileged access workstations, conditional access, and separation of administrative tiers.

Third, organizations must monitor SaaS in the same way as any other production infrastructure. Admin actions, impersonation, mass exports, OAuth app grants, API-token creation, SSO changes, and abnormal downloads should be logged and fed to SIEM.

Fourth, organizations must monitor their networks for early signs of theft. Bulk compression, abnormal database exports, unexpected outbound transfers, massive object downloads, and suspicious access to sensitive repositories must trigger alerts. The ransomware note usually appears to be the last step in the process.

Fifth, organizations must rehearse downtime procedures. Hospitals should have paper workflows prepared. Municipalities should have an alternative method to accept payment. Schools should be able to communicate independently. Manufacturers should have a manual continuity plan. Business continuity is now a Cybersecurity discipline.

Finally, the ransom decision process should be planned in advance. The FBI advises against ransom payments because they cannot guarantee recovery of the data and encourage further attacks. However, executives should have the decision process prepared in case something goes wrong during the attack.

## Conclusion

The latest trend in ransomware is not accidental. Attackers target organizations where availability of services, sensitive data, dependency on third-parties, and trust of the public intersect. The solution is not just about better malware detection. It is all about cyber-ecosystem resilient architecture which entails hardened IAM, segmented systems, Zero-trust ecosystems, Honey farms, resilient end-point protections, SaaS monitoring, proven backups, rehearsed downtime procedures, and deliberate dogged C-Suite driven incident response.

Organizations that fare well during ransomware attacks are not the ones that never get hit. These are the organizations that can contain the damage, understand the threat, restore cleanly, and continue operations under the pressure.

## References

- AP News. "Mississippi hospital system closes all clinics after ransomware attack."
- BridgePay / Government Technology reporting. "Cyber attack disrupts local government payment systems."
- CISA. "StopRansomware Guide."
- FBI. "Ransomware."
- Guardian. "Canvas hack: is it ever a good idea to pay a ransom, and what happens to the data?"
- Halcyon. "Nitrogen Ransomware on a Manufacturer Attack Spree."
- HIPAA Journal. "Brockton Hospital Ransomware Attack: Downtime Procedures Implemented."
- Higher Ed Dive. "Canvas owner reaches agreement with threat actors after data breach."
- TechRadar. "Foxconn confirms cyberattack hit some North American factories."
- The Record. "Nearly 480,000 impacted by Covenant Health data breach."
