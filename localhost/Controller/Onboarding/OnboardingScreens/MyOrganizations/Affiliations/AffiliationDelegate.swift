//
//  AffiliationDelegate.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/31/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

protocol AffiliationDelegate: class {
    func didAddAffiliation(_ affiliation: Affiliation)
    func didEditAffiliation(_ editedAffiliation: Affiliation, _ affiliationDescription: AffiliationDescription)
    func didDeleteAffiliation(_ deletedAffiliation: Affiliation, _ affiliationDescription: AffiliationDescription)
    func showEditAffiliation(_ affiliationDescription: AffiliationDescription)
}
