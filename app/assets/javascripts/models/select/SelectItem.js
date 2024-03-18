// @flow
import type { Company } from '../companies/Company';

export type SelectItem = {
  value: number,
  label: string,
};

export function fromCompany(companies: Array<Company>): Array<SelectItem> {
  return companies.map(company => ({
    value: company.id,
    label: company.name,
  }));
}
